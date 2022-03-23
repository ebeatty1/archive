#!/usr/bin/perl
use strict; use warnings;
use Getopt::Long qw(GetOptions);
use XML::LibXML;
use JSON;

my $version = '1.0';
my $name = 'varsome.pl';

my $usage = <<"END_USAGE";

NAME                    $name
VERSION                 $version
SYNOPSIS                Pulls disease data from the Varsome API.
COMMAND                 $name --api-key 0123456789012345678901
                        $name --sym-list list.txt --api-key 0123456789012345678901
                        $name --sym-list list.txt --api-key 0123456789012345678901 2>/dev/null

OPTIONS:
 -h (--help)            Prints this message.
 -l (--sym-list) FILE   Use a plain text file containing HGNC-approved gene symbols.
                        Optional. Will use a defualt list if not specified.
                            FILE=path of list file
 -k (--api-key) KEY     Required for the script to function. Varsome API key.
                            KEY=api key

END_USAGE

# getopt vars
my $help;
my $symbolListFile;
my $apikey = '0123456789012345678901';

GetOptions(
	'h|help' =>         \$help,
    'l|sym-list=s' =>   \$symbolListFile,
    'k|api-key=s' =>    \$apikey
);

die $usage if $help;

# default gene list
my @symbolList = ('ABCB11', 'GATC', 'GBA'); # GATC, GBA
my %geneData = {};

# if -l
if ($symbolListFile)
{
    open my $symbolListIn, "<", "$symbolListFile" or die "Can't open $symbolListFile\n";
    @symbolList = ();
    while (my $line = <$symbolListIn>)
    {
        chomp($line);
        push(@symbolList, $line); 
    }
    close $symbolListIn;

    print "Using list from file\n";
}

# else use default list
else { print "No list provided; using default: @symbolList\n" }

foreach my $symbol (@symbolList)
{
    my %variantData = {};

    my $raw = `curl.exe -s -v -H "Authorization: Token $apikey" https://staging-api.varsome.com/lookup/gene/$symbol/hg38?add-source-databases=saphetor_known_pathogenicity`;
    my $decoded = decode_json($raw);

    my $i = 0;
    foreach my $item (@{ $decoded->{'saphetor_known_pathogenicity'}{'items'} }) 
    { 
        if ($i > 0) 
        { 
            print "More than one JSON array found inside of $symbol. Investigate.\n"; 
            next; 
        }

        $variantData{'total_pathogenic'}        = $item->{'pathogenic'};
        $variantData{'nonsense'}                = generateVariantArray('nonsense', $item);
        $variantData{'missense'}                = generateVariantArray('missense', $item);
        $variantData{'start_loss'}              = generateVariantArray('start_loss', $item);
        $variantData{'stoploss'}                = generateVariantArray('stoploss', $item);
        $variantData{'splice_junction_loss'}    = generateVariantArray('splice_junction_loss', $item);
        $variantData{'exon_deletion'}           = generateVariantArray('exon_deletion', $item);
        $variantData{'frameshift'}              = generateVariantArray('frameshift', $item);
        $variantData{'non_coding'}              = generateVariantArray('non_coding', $item);
        $variantData{'in_frame'}                = generateVariantArray('in_frame', $item);

        $i++;
    }

    $geneData{$symbol} = \%variantData;
}

foreach my $symbol (@symbolList)
{   
    my $hash = \%geneData;

    # printing option A: all data printed separately
    # print "$symbol\tnonsense\tP\t".@{ $hash->{$symbol}{'nonsense'} }[0]."\n";
    # print "$symbol\tnonsense\tLP\t".@{ $hash->{$symbol}{'nonsense'} }[1]."\n";
    # print "$symbol\tmissense\tP\t".@{ $hash->{$symbol}{'missense'} }[0]."\n";
    # print "$symbol\tmissense\tLP\t".@{ $hash->{$symbol}{'missense'} }[1]."\n";
    # print "$symbol\tstart_loss\tP\t".@{ $hash->{$symbol}{'start_loss'} }[0]."\n";
    # print "$symbol\tstart_loss\tLP\t".@{ $hash->{$symbol}{'start_loss'} }[1]."\n";
    # print "$symbol\tstoploss\tP\t".@{ $hash->{$symbol}{'stoploss'} }[0]."\n";
    # print "$symbol\tstoploss\tLP\t".@{ $hash->{$symbol}{'stoploss'} }[1]."\n";
    # print "$symbol\tsplice_junction_loss\tP\t".@{ $hash->{$symbol}{'splice_junction_loss'} }[0]."\n";
    # print "$symbol\tsplice_junction_loss\tLP\t".@{ $hash->{$symbol}{'splice_junction_loss'} }[1]."\n";
    # print "$symbol\texon_deletion\tP\t".@{ $hash->{$symbol}{'exon_deletion'} }[0]."\n";
    # print "$symbol\texon_deletion\tLP\t".@{ $hash->{$symbol}{'exon_deletion'} }[1]."\n";
    # print "$symbol\tframeshift\tP\t".@{ $hash->{$symbol}{'frameshift'} }[0]."\n";
    # print "$symbol\tframeshift\tLP\t".@{ $hash->{$symbol}{'frameshift'} }[1]."\n";
    # print "$symbol\tnon_coding\tP\t".@{ $hash->{$symbol}{'non_coding'} }[0]."\n";
    # print "$symbol\tnon_coding\tLP\t".@{ $hash->{$symbol}{'non_coding'} }[1]."\n";
    # print "$symbol\tin_frame\tP\t".@{ $hash->{$symbol}{'in_frame'} }[0]."\n";
    # print "$symbol\tin_frame\tLP\t".@{ $hash->{$symbol}{'in_frame'} }[1]."\n";

    # printing option B: condensed for Excel; P+LP
    # symbol nonsense missense start_loss stoploss splice_junction_loss exon_deletion frameshift non_coding in_frame
    # print "$symbol\t".((@{ $hash->{$symbol}{'nonsense'} }[0]) + (@{ $hash->{$symbol}{'nonsense'} }[1]))."\t".
    #                   ((@{ $hash->{$symbol}{'missense'} }[0]) + (@{ $hash->{$symbol}{'missense'} }[1]))."\t".
    #                   ((@{ $hash->{$symbol}{'start_loss'} }[0]) + (@{ $hash->{$symbol}{'start_loss'} }[1]))."\t".
    #                   ((@{ $hash->{$symbol}{'stoploss'} }[0]) + (@{ $hash->{$symbol}{'stoploss'} }[1]))."\t".
    #                   ((@{ $hash->{$symbol}{'splice_junction_loss'} }[0]) + (@{ $hash->{$symbol}{'splice_junction_loss'} }[1]))."\t".
    #                   ((@{ $hash->{$symbol}{'exon_deletion'} }[0]) + (@{ $hash->{$symbol}{'exon_deletion'} }[1]))."\t".
    #                   ((@{ $hash->{$symbol}{'frameshift'} }[0]) + (@{ $hash->{$symbol}{'frameshift'} }[1]))."\t".
    #                   ((@{ $hash->{$symbol}{'non_coding'} }[0]) + (@{ $hash->{$symbol}{'non_coding'} }[1]))."\t".
    #                   ((@{ $hash->{$symbol}{'in_frame'} }[0]) + (@{ $hash->{$symbol}{'in_frame'} }[1]))."\n";

    # printing option C: further condensed for Excel; P+LP
    # symbol missense start_loss stoploss [nonsense + frameshift + splice_junction_loss + in_frame] non_coding exon_deletion
    print "$symbol\t".((@{ $hash->{$symbol}{'missense'} }[0]) + (@{ $hash->{$symbol}{'missense'} }[1]))."\/".$hash->{$symbol}{'total_pathogenic'}."\t".
                      ((@{ $hash->{$symbol}{'start_loss'} }[0]) + (@{ $hash->{$symbol}{'start_loss'} }[1]))."\/".$hash->{$symbol}{'total_pathogenic'}."\t".
                      ((@{ $hash->{$symbol}{'stoploss'} }[0]) + (@{ $hash->{$symbol}{'stoploss'} }[1]))."\/".$hash->{$symbol}{'total_pathogenic'}."\t".

                      ((@{ $hash->{$symbol}{'nonsense'} }[0]) + (@{ $hash->{$symbol}{'nonsense'} }[1]) + 
                       (@{ $hash->{$symbol}{'frameshift'} }[0]) + (@{ $hash->{$symbol}{'frameshift'} }[1]) + 
                       (@{ $hash->{$symbol}{'splice_junction_loss'} }[0]) + (@{ $hash->{$symbol}{'splice_junction_loss'} }[1]) + 
                       (@{ $hash->{$symbol}{'in_frame'} }[0]) + (@{ $hash->{$symbol}{'in_frame'} }[1]))."\/".$hash->{$symbol}{'total_pathogenic'}."\t".

                      ((@{ $hash->{$symbol}{'non_coding'} }[0]) + (@{ $hash->{$symbol}{'non_coding'} }[1]))."\/".$hash->{$symbol}{'total_pathogenic'}."\t".
                      ((@{ $hash->{$symbol}{'exon_deletion'} }[0]) + (@{ $hash->{$symbol}{'exon_deletion'} }[1]))."\/".$hash->{$symbol}{'total_pathogenic'}."\n";
}

sub generateVariantArray()
{
    die "Not enough arguments for array generation subroutine\n" unless (scalar(@_) > 1);
    my $variantType = shift @_;
    my $jsonObjRef = shift @_;
    my @array = ();

    foreach my $vcount (@{ $jsonObjRef->{$variantType} }) { push(@array, $vcount); }
    
    return \@array;
}