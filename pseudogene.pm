use warnings; use strict;

package pseudogene;

sub new
{
    my $class = shift;
    my $raw_entry = shift;
    my @entry = split("\t", $raw_entry, -1);
    die "Encountered entry that doesn't match expected Pseudogene.org format.\n" unless (scalar(@entry) == 23 || scalar(@entry) == 24);

    my $self = bless {  
        pseudogene_id => $entry[0],                         # 0
        chromosome => $entry[1],                            # 1
        unknown_2 => $entry[2],                             # 2     # 7- to 9-digit number
        unknown_3 => $entry[3],                             # 3     # 7- to 9-digit number
        unknown_4 => $entry[4],                             # 4     # either + or -; likely indel
        ensembl_prot_id => $entry[5],                       # 5
        unknown_6 => $entry[6],                             # 6     # 1- to 4-digit number
        unknown_7 => $entry[7],                             # 7     # 2- to 4-digit number
        ensembl_gene_id => $entry[8],                       # 8
        unknown_9 => $entry[9],                             # 9     # value between 0 and 1; likely homology or a p-value
        unknown_10 => $entry[10],                           # 10    # 1- to 2-digit number
        unknown_11 => $entry[11],                           # 11    # 1- to 2-digit number
        unknown_12 => $entry[12],                           # 12    # 1- to 2-digit number
        unknown_13 => $entry[13],                           # 13    # 1- to 2-digit number
        unknown_14 => $entry[14],                           # 14    # number in scientific notation; always below 0
        unknown_15 => $entry[15],                           # 15    # value between 0 and 1; likely homology or a p-value
        unknown_16 => $entry[16],                           # 16    # value between 0 and 3; likely a type or group of some sort
        unknown_17 => $entry[17],                           # 17    # Yes or No
        unknown_18 => $entry[18],                           # 18    # a combination of unknown_2 and unknown_3, in double brackets; sometimes has more values
        unknown_19 => $entry[19],                           # 19    # empty brackets in most cases
        status => $entry[20],                               # 20
        sequence => $entry[21],                             # 21
        unknown_22 => $entry[22],                           # 22    # combination of ensembl_prot_id and some other values; formatted
        new_addition => $entry[23]                          # 23    # optional
    }, $class;

    return $self;
}

sub get_pseudogene_id
{
    # 0
    my $self = shift;
    return $self->{pseudogene_id};
}

sub get_chromosome
{
    # 1
    my $self = shift;
    return $self->{chromosome};
}

sub get_unknown_2
{
    # 2
    my $self = shift;
    return $self->{unknown_2};
}

sub get_unknown_3
{
    # 3
    my $self = shift;
    return $self->{unknown_3};
}

sub get_unknown_4
{
    # 4
    my $self = shift;
    return $self->{unknown_4};
}

sub get_ensembl_prot_id
{
    # 5
    my $self = shift;
    return $self->{ensembl_prot_id};
}

sub get_unknown_6
{
    # 6
    my $self = shift;
    return $self->{unknown_6};
}

sub get_unknown_7
{
    # 7
    my $self = shift;
    return $self->{unknown_7};
}

sub get_ensembl_gene_id
{
    # 8
    my $self = shift;
    return $self->{ensembl_gene_id};
}

sub get_unknown_9
{
    # 9
    my $self = shift;
    return $self->{unknown_9};
}

sub get_unknown_10
{
    # 10
    my $self = shift;
    return $self->{unknown_10};
}

sub get_unknown_11
{
    # 11
    my $self = shift;
    return $self->{unknown_11};
}

sub get_unknown_12
{
    # 12
    my $self = shift;
    return $self->{unknown_12};
}

sub get_unknown_13
{
    # 13
    my $self = shift;
    return $self->{unknown_13};
}

sub get_unknown_14
{
    # 14
    my $self = shift;
    return $self->{unknown_14};
}

sub get_unknown_15
{
    # 15
    my $self = shift;
    return $self->{unknown_15};
}

sub get_unknown_16
{
    # 16
    my $self = shift;
    return $self->{unknown_16};
}

sub get_unknown_17
{
    # 17
    my $self = shift;
    return $self->{unknown_17};
}

sub get_unknown_18
{
    # 18
    my $self = shift;
    return $self->{unknown_18};
}

sub get_unknown_19
{
    # 19
    my $self = shift;
    return $self->{unknown_19};
}

sub get_status
{
    # 20
    my $self = shift;
    return $self->{status};
}

sub get_sequence
{
    # 21
    my $self = shift;
    return $self->{sequence};
}

sub get_unknown_22
{
    # 22
    my $self = shift;
    return $self->{unknown_22};
}

sub get_new_addition
{
    # 23
    my $self = shift;
    return $self->{new_addition};
}

1;