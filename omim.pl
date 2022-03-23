#!/usr/bin/perl
use strict; use warnings;
use Getopt::Long qw(GetOptions);
use XML::LibXML;

my $version = '1.1';
my $name = 'omim.pl';

my $usage = <<"END_USAGE";

NAME                    $name
VERSION                 $version
SYNOPSIS                Pulls disease data from the OMIM API.
COMMAND                 $name --api-key 0123456789012345678901
                        $name --mim-list list.txt --api-key 0123456789012345678901
                        $name --mim-list list.txt --api-key 0123456789012345678901 2>/dev/null

OPTIONS:
 -h (--help)            Prints this message.
 -l (--mim-list) FILE   Use a plain text file containing OMIM numbers.
                        Optional. Will use a defualt list if not specified.
                            FILE=path of list file
 -k (--api-key) KEY     Required for the script to function. OMIM API key.
                            KEY=api key

END_USAGE

# getopt vars
my $help;
my $omimListFile;
my $apikey = '0123456789012345678901';

GetOptions(
	'h|help' =>         \$help,
    'l|mim-list=s' =>   \$omimListFile,
    'k|api-key=s' =>    \$apikey
);

die $usage if $help;

# default gene list
my @omimList =  ('617210', '606463'); # GATC, GBA

# if -l
if ($omimListFile)
{
    open my $omimListIn, "<", "$omimListFile" or die "Can't open $omimListFile\n";
    @omimList = ();
    while (my $line = <$omimListIn>)
    {
        chomp($line);
        push(@omimList, $line); 
    }
    close $omimListIn;

    print "Using list from file\n";
}

# else use default list
else { print "No list provided; using default: @omimList\n" }

foreach my $omimNumber (@omimList)
{
    my $raw = `curl.exe -s -v -H "apikey: $apikey" https://api.omim.org/api/entry?mimNumber=$omimNumber&include=geneMap`;
    my $xmlobj = XML::LibXML->load_xml(string => $raw);
    my $genesymbol = $xmlobj->findnodes('/omim/entryList/entry/geneMap/approvedGeneSymbols');
    # print $omimNumber."\t".$genesymbol->to_literal()."\n";
    
    if (!($xmlobj->findnodes('/omim/entryList/entry/geneMap/phenotypeMapList/phenotypeMap')))
    {
        print $omimNumber."\t".$genesymbol->to_literal()."\n";
    }
    else
    {
        foreach my $phenmap ($xmlobj->findnodes('/omim/entryList/entry/geneMap/phenotypeMapList/phenotypeMap')) {
            my $phenotype = $phenmap->findnodes('./phenotype');
            my $phenmim = $phenmap->findnodes('./phenotypeMimNumber');
            my $pheninheritance = $phenmap->findnodes('./phenotypeInheritance');
            my $phenkey = $phenmap->findnodes('./phenotypeMappingKey');
            print $genesymbol->to_literal()."\t".$omimNumber."\t";
            print $phenotype->to_literal()."\t".$phenmim->to_literal()."\t".$phenkey->to_literal()."\t".$pheninheritance->to_literal()."\n";
        }
    }

}