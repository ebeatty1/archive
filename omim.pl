#!/usr/bin/perl
use strict; use warnings;
use Getopt::Long qw(GetOptions);
use File::Basename;
use lib dirname (__FILE__);
use omim;

my $version = '1.0';
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

# use default list
else { print "No list provided; using default: @omimList\n" }

foreach my $omimNumber (@omimList)
{
    my $raw = `curl -s -v -H "apikey: $apikey" 'https://api.omim.org/api/entry?mimNumber=$omimNumber&include=geneMap'`;
    my @rawSplit = split('\n', $raw);
    my @phenotypes = ();

    foreach my $line (@rawSplit)
    {
        if ($line =~ m/\<phenotype\>(.*)\<\/phenotype\>/)
        {
            if (!(grep(/^\Q$1\E$/, @phenotypes)))
            {
                push(@phenotypes, $1);
            }
        }
    }

    my $counter = 0;
    print $omimNumber."\t";
    # my $combinedPhenotypes = '';
    foreach my $phenotype (@phenotypes)
    {
        if ($counter > 0 && $counter < scalar(@phenotypes))
        {
            print " | ";
        }
        print $phenotype;
        $counter++;
    }
    print "\n";
}