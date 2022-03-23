use warnings; use strict;

package pseudogene_similarity;

sub new
{
    my $class = shift;
    my $raw_entry = shift;
    my @entry = split("\t", $raw_entry, -1);
    die "Encountered entry that doesn't match expected Pseudogene.org similarity format.\n" unless (scalar(@entry) == 4);

    my $self = bless {  
        parent_ensemble_transcript_id => $entry[0],         # 0     # ENST
        pseudogene_ensemble_transcript_id => $entry[1],     # 1     # ENST
        body => $entry[2],                                  # 2     # 
        utr => $entry[3],                                   # 3     # 
    }, $class;

    return $self;
}

sub get_parent_ensemble_transcript_id
{
    # 0
    my $self = shift;
    return $self->{parent_ensemble_transcript_id};
}

sub get_pseudogene_ensemble_transcript_id
{
    # 1
    my $self = shift;
    return $self->{pseudogene_ensemble_transcript_id};
}

sub get_body
{
    # 2
    my $self = shift;
    return $self->{body};
}

sub get_utr
{
    # 3
    my $self = shift;
    return $self->{utr};
}

1;