#!/usr/bin/perl
use strict; use warnings;
use Getopt::Long qw(GetOptions);
use File::Basename;
use lib dirname (__FILE__);
use pseudogene;

my $version = '1.0';
my $name = 'pseudogene.pl';

my $usage = <<"END_USAGE";

NAME                    $name
VERSION                 $version
SYNOPSIS                Pulls data from the Pseudogene.org PseudoPipe archive.
COMMAND                 $name --archive archive.txt --gene-list list.txt

OPTIONS:
 -h (--help)            Prints this message.
 -a (--archive) FILE    Tells the script which archive file to use.
                        Optional. The script will look to ./db/Human90.txt if not specified.
                            FILE=path of archive file
 -g (--gene-list) FILE  Use a plain text file containing gene identifiers. Must be a list of parent Ensembl gene ID's.
                        Optional. Will use a defualt list if not specified.
                            FILE=path of list file
                            
END_USAGE

# getopt vars
my $help;
my $archiveFile = './db/Human90.txt';
my $listFile;

GetOptions(
	'h|help' =>         \$help,
    'a|archive=s' =>    \$archiveFile,
    'g|gene-list=s' =>  \$listFile
);

die $usage if $help;

# default gene list
my @parentList =  ('ENSG00000001626', 'ENSG00000172817'); # CFTR, CYP7B1

# if -g
if ($listFile)
{
    open my $parentListIn, "<", "$listFile" or die "Can't open $listFile\n";
    @parentList = ();
    while (my $line = <$parentListIn>)
    {
        chomp($line);
        push(@parentList, $line); 
    }
    close $parentListIn;

    print "Using list from file\n";
}

# use default list
else { print "No list provided; using default: @parentList\n" }

# open the archive and process it
open my $archiveIn, "<", "$archiveFile" or die "Can't open $archiveFile\n";
while (my $line = <$archiveIn>)
{
    chomp($line);
    my $pseudogene_entry = pseudogene->new($line);

    my $identifier = $pseudogene_entry->get_parent_ensembl_gene_id();
    if (grep(/$identifier/, @parentList))
    {
        print   $pseudogene_entry->get_pseudogene_id()."\t".
                $pseudogene_entry->get_parent_ensembl_gene_id()."\t".
                $pseudogene_entry->get_identity()."\t".
                $pseudogene_entry->get_overlap()."\t".
                $pseudogene_entry->get_pvalue()."\n";
    }
}
close $archiveIn;