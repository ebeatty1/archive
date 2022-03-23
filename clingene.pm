use warnings; use strict;

package clingene;

sub new
{
    my $class = shift;
    my $raw_entry = shift;
    my @entry = split("\t", $raw_entry, -1);
    die "Encountered entry that doesn't match expected ClinGene format.\n" unless (scalar(@entry) == 10);

    my $self = bless {  
        symbol => $entry[0],                                # 0
        hgnc_id => $entry[1],                               # 1     
        disease_label => $entry[2],                         # 2
        mondo_id => $entry[3],                              # 3
        moi => $entry[4],                                   # 4     # model of inheritance
        sop => $entry[5],                                   # 5     # unknown
        classification => $entry[6],                        # 6
        link => $entry[7],                                  # 7
        classification_date => $entry[8],                   # 8
        gcep => $entry[9]                                   # 9     # unknown
    }, $class;

    return $self;
}

sub get_symbol
{
    # 0
    my $self = shift;
    return $self->{symbol};
}

sub get_hgnc_id
{
    # 1
    my $self = shift;
    return $self->{hgnc_id};
}

sub get_disease_label
{
    # 2
    my $self = shift;
    return $self->{disease_label};
}

sub get_mondo_id
{
    # 3
    my $self = shift;
    return $self->{mondo_id};
}

sub get_moi
{
    # 4
    my $self = shift;
    return $self->{moi};
}

sub get_sop
{
    # 5
    my $self = shift;
    return $self->{sop};
}

sub get_classification
{
    # 6
    my $self = shift;
    return $self->{classification};
}

sub get_link
{
    # 7
    my $self = shift;
    return $self->{link};
}

sub get_classification_date
{
    # 8
    my $self = shift;
    return $self->{classification_date};
}

sub get_gcep
{
    # 9
    my $self = shift;
    return $self->{gcep};
}

1;