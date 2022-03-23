use warnings; use strict;

package pseudogene;

sub new
{
    my $class = shift;
    my $raw_entry = shift;
    my @entry = split("\t", $raw_entry, -1);
    die "Encountered entry that doesn't match expected Pseudogene.org format.\n" unless (scalar(@entry) == 23 || scalar(@entry) == 24);

    my $self = bless {  
        pseudogene_id => $entry[0],                         # 0     # Yale pseudogene ID
        chromosome => $entry[1],                            # 1     
        tstart => $entry[2],                                # 2     # transcription start position
        tend => $entry[3],                                  # 3     # transcription end position
        strand => $entry[4],                                # 4     
        parent_ensembl_prot_id => $entry[5],                # 5     # parent ENSP
        parent_tstart => $entry[6],                         # 6
        parent_tend => $entry[7],                           # 7
        parent_ensembl_gene_id => $entry[8],                # 8     # Parent ENSG
        overlap => $entry[9],                               # 9
        insertions => $entry[10],                           # 10
        deletions => $entry[11],                            # 11
        shifts => $entry[12],                               # 12
        stop_codons => $entry[13],                          # 13
        pvalue => $entry[14],                               # 14
        identity => $entry[15],                             # 15
        polyA => $entry[16],                                # 16
        obs_1 => $entry[17],                                # 17    # unused; ignore
        exons => $entry[18],                                # 18
        introns => $entry[19],                              # 19
        biotype => $entry[20],                              # 20
        sequence => $entry[21],                             # 21
        database_identifier => $entry[22],                  # 22
        obs_2 => $entry[23]                                 # 23    # unused; ignore
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

sub get_tstart
{
    # 2
    my $self = shift;
    return $self->{tstart};
}

sub get_tend
{
    # 3
    my $self = shift;
    return $self->{tend};
}

sub get_strand
{
    # 4
    my $self = shift;
    return $self->{strand};
}

sub get_parent_ensembl_prot_id
{
    # 5
    my $self = shift;
    return $self->{parent_ensembl_prot_id};
}

sub get_parent_tstart
{
    # 6
    my $self = shift;
    return $self->{parent_tstart};
}

sub get_parent_tend
{
    # 7
    my $self = shift;
    return $self->{parent_tend};
}

sub get_parent_ensembl_gene_id
{
    # 8
    my $self = shift;
    return $self->{parent_ensembl_gene_id};
}

sub get_overlap
{
    # 9
    my $self = shift;
    return $self->{overlap};
}

sub get_insertions
{
    # 10
    my $self = shift;
    return $self->{insertions};
}

sub get_deletions
{
    # 11
    my $self = shift;
    return $self->{deletions};
}

sub get_shifts
{
    # 12
    my $self = shift;
    return $self->{shifts};
}

sub get_stop_codons
{
    # 13
    my $self = shift;
    return $self->{stop_codons};
}

sub get_pvalue
{
    # 14
    my $self = shift;
    return $self->{pvalue};
}

sub get_identity
{
    # 15
    my $self = shift;
    return $self->{identity};
}

sub get_polyA
{
    # 16
    my $self = shift;
    return $self->{polyA};
}

sub get_obs_1
{
    # 17
    my $self = shift;
    return $self->{obs_1};
}

sub get_exons
{
    # 18
    my $self = shift;
    return $self->{exons};
}

sub get_introns
{
    # 19
    my $self = shift;
    return $self->{introns};
}

sub get_biotype
{
    # 20
    my $self = shift;
    return $self->{biotype};
}

sub get_sequence
{
    # 21
    my $self = shift;
    return $self->{sequence};
}

sub get_database_identifier
{
    # 22
    my $self = shift;
    return $self->{database_identifier};
}

sub get_obs_2
{
    # 23
    my $self = shift;
    return $self->{obs_2};
}

1;