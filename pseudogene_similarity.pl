#!/usr/bin/perl
use strict; use warnings;
use Getopt::Long qw(GetOptions);
use File::Basename;
use lib dirname (__FILE__);
use pseudogene;
# use pseudogene_similarity;

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
                        Optional. The script will look for a file named Human90.txt in the current dir if not specified.
                            FILE=path of archive file
 -g (--gene-list) FILE  Use a plain text file containing gene identifiers. Identifiers can be either OMIM #'s or HGNC-approved symbols.
                        Optional. Will use a defualt list if not specified.
                            FILE=path of list file
END_USAGE

# getopt vars
my $help;
my $archiveFile = 'Human90.txt';
my $pseudogeneListFile;
my $omimList;
my $symbolList;

GetOptions(
	'h|help' =>         \$help,
    'a|archive=s' =>    \$archiveFile,
    'g|gene-list=s' =>  \$pseudogeneListFile
);

die $usage if $help;

# default gene list
my @pseudogeneList =  ('PGOHUM00000243077', 'PGOHUM00000240018', 'PGOHUM00000304336', 'PGOHUM00000241628'); # ASS1P1, ASS1P2, ASS1P3, ASS1P4
my %pseudogene_obj;
my %pseudogene_obj_ensembl;

# if -g
if ($pseudogeneListFile)
{
    open my $pseudogeneListIn, "<", "$pseudogeneListFile" or die "Can't open $pseudogeneListFile\n";
    @pseudogeneList = ();
    while (my $line = <$pseudogeneListIn>)
    {
        chomp($line);
        push(@pseudogeneList, $line); 
    }
    close $pseudogeneListIn;

    print "Using list from file\n";
}

# use default list
else { print "No list provided; using default: @pseudogeneList\n" }

# open the archive and process it
open my $archiveIn, "<", "$archiveFile" or die "Can't open $archiveFile\n";
while (my $line = <$archiveIn>)
{
    chomp($line);
    my $pseudogene_entry = pseudogene->new($line);
    
    $pseudogene_obj{$pseudogene_entry->get_pseudogene_id()} = $pseudogene_entry;
    $pseudogene_obj_ensembl{$pseudogene_entry->get_ensembl_gene_id()} = $pseudogene_entry;

}
close $archiveIn;

# look through the list for pseudogene id's
foreach my $pseudogene_id (@pseudogeneList)
{
    if (exists $pseudogene_obj{$pseudogene_id})
    {
        print   $pseudogene_obj{$pseudogene_id}->get_pseudogene_id()."\t".
                $pseudogene_obj{$pseudogene_id}->get_ensembl_gene_id()."\t".
                $pseudogene_obj{$pseudogene_id}->get_ensembl_prot_id()."\t".
                $pseudogene_obj{$pseudogene_id}->get_tstart()."\t".
                $pseudogene_obj{$pseudogene_id}->get_tend()."\t".
                $pseudogene_obj{$pseudogene_id}->get_chromosome();

        print $pseudogene_obj{$pseudogene_id}->get_new_addition() if (defined($pseudogene_obj{$pseudogene_id}->get_new_addition()));
        print "\n";
    }
}

# look through the list for ensembl gene id's
foreach my $ensembl_gene_id (@pseudogeneList)
{
    if (exists $pseudogene_obj_ensembl{$ensembl_gene_id})
    {
        print   $pseudogene_obj_ensembl{$ensembl_gene_id}->get_pseudogene_id()."\t".
                $pseudogene_obj_ensembl{$ensembl_gene_id}->get_ensembl_gene_id()."\t".
                $pseudogene_obj_ensembl{$ensembl_gene_id}->get_ensembl_prot_id()."\t".
                $pseudogene_obj_ensembl{$ensembl_gene_id}->get_tstart()."\t".
                $pseudogene_obj_ensembl{$ensembl_gene_id}->get_tend()."\t".
                $pseudogene_obj_ensembl{$ensembl_gene_id}->get_chromosome();

        print $pseudogene_obj_ensembl{$ensembl_gene_id}->get_new_addition() if (defined($pseudogene_obj_ensembl{$ensembl_gene_id}->get_new_addition()));
        print "\n";
    }
}