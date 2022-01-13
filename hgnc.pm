use warnings; use strict;

package hgnc_gene;

sub new
{
    my $class = shift;
    my $raw_entry = shift;
    my @entry = split("\t", $raw_entry, -1);
    die "Encountered entry that doesn't match expected HGNC format.\n" unless (scalar(@entry) == 54);

    my $self = bless {  
        hgnc_id => $entry[0],                               # 0
        symbol => $entry[1],                                # 1
        name => $entry[2],                                  # 2
        locus_group => $entry[3],                           # 3
        locus_type => $entry[4],                            # 4
        status => $entry[5],                                # 5
        location => $entry[6],                              # 6
        location_sortable => $entry[7],                     # 7
        alias_symbol => $entry[8],                          # 8
        alias_name => $entry[9],                            # 9
        prev_symbol => $entry[10],                          # 10
        prev_name => $entry[11],                            # 11
        gene_group => $entry[12],                           # 12
        gene_group_id => $entry[13],                        # 13
        date_approved_reserved => $entry[14],               # 14
        date_symbol_changed => $entry[15],                  # 15
        date_name_changed => $entry[16],                    # 16
        date_modified => $entry[17],                        # 17
        entrez_id => $entry[18],                            # 18
        ensembl_gene_id => $entry[19],                      # 19
        vega_id => $entry[20],                              # 20
        ucsc_id => $entry[21],                              # 21
        ena => $entry[22],                                  # 22
        refseq_accession => $entry[23],                     # 23
        ccds_id => $entry[24],                              # 24
        uniprot_ids => $entry[25],                          # 25
        pubmed_id => $entry[26],                            # 26
        mgd_id => $entry[27],                               # 27
        rgd_id => $entry[28],                               # 28
        lsdb => $entry[29],                                 # 29
        cosmic => $entry[30],                               # 30
        omim_id => $entry[31],                              # 31
        mirbase => $entry[32],                              # 32
        homeodb => $entry[33],                              # 33
        snornabase => $entry[34],                           # 34
        bioparadigms_slc => $entry[35],                     # 35
        orphanet => $entry[36],                             # 36
        pseudogene_id => $entry[37],                        # 37
        horde_id => $entry[38],                             # 38
        merops => $entry[39],                               # 39
        imgt => $entry[40],                                 # 40
        iuphar => $entry[41],                               # 41
        kznf_gene_catalog => $entry[42],                    # 42
        mamit_trnadb => $entry[43],                         # 43
        cd => $entry[44],                                   # 44
        lncrnadb => $entry[45],                             # 45
        enzyme_id => $entry[46],                            # 46
        intermediate_filament_db => $entry[47],             # 47
        rna_central_ids => $entry[48],                      # 48
        lncipedia => $entry[49],                            # 49
        gtrnadb => $entry[50],                              # 50
        agr => $entry[51],                                  # 51
        mane_select => $entry[52],                          # 52
        gencc => $entry[53]                                 # 53
    }, $class;

    return $self;
}

sub get_hgnc_id
{
    # 0
    my $self = shift;
    return $self->{hgnc_id};
}

sub get_symbol
{
    # 1
    my $self = shift;
    return $self->{symbol};
}

sub get_name
{
    # 2
    my $self = shift;
    return $self->{name};
}

sub get_locus_group
{
    # 3
    my $self = shift;
    return $self->{locus_group};
}

sub get_locus_type
{
    # 4
    my $self = shift;
    return $self->{locus_type};
}

sub get_status
{
    # 5
    my $self = shift;
    return $self->{status};
}

sub get_location
{
    # 6
    my $self = shift;
    return $self->{location};
}

sub get_location_sortable
{
    # 7
    my $self = shift;
    return $self->{location_sortable};
}

sub get_alias_symbol
{
    # 8
    my $self = shift;
    return $self->{alias_symbol};
}

sub get_alias_name
{
    # 9
    my $self = shift;
    return $self->{alias_name};
}

sub get_prev_symbol
{
    # 10
    my $self = shift;
    return $self->{prev_symbol};
}

sub get_prev_name
{
    # 11
    my $self = shift;
    return $self->{prev_name};
}

sub get_gene_group
{
    # 12
    my $self = shift;
    return $self->{gene_group};
}

sub get_gene_group_id
{
    # 13
    my $self = shift;
    return $self->{gene_group_id};
}

sub get_date_approved_reserved
{
    # 14
    my $self = shift;
    return $self->{date_approved_reserved};
}

sub get_date_symbol_changed
{
    # 15
    my $self = shift;
    return $self->{date_symbol_changed};
}

sub get_date_name_changed
{
    # 16
    my $self = shift;
    return $self->{date_name_changed};
}

sub get_date_modified
{
    # 17
    my $self = shift;
    return $self->{date_modified};
}

sub get_entrez_id
{
    # 18
    my $self = shift;
    return $self->{entrez_id};
}

sub get_ensembl_gene_id
{
    # 19
    my $self = shift;
    return $self->{ensembl_gene_id};
}

sub get_vega_id
{
    # 20
    my $self = shift;
    return $self->{vega_id};
}

sub get_ucsc_id
{
    # 21
    my $self = shift;
    return $self->{ucsc_id};
}

sub get_ena
{
    # 22
    my $self = shift;
    return $self->{ena};
}

sub get_refseq_accession
{
    # 23
    my $self = shift;
    return $self->{refseq_accession};
}

sub get_ccds_id
{
    # 24
    my $self = shift;
    return $self->{ccds_id};
}

sub get_uniprot_ids
{
    # 25
    my $self = shift;
    return $self->{uniprot_ids};
}

sub get_pubmed_id
{
    # 26
    my $self = shift;
    return $self->{pubmed_id};
}

sub get_mgd_id
{
    # 27
    my $self = shift;
    return $self->{mgd_id};
}

sub get_rgd_id
{
    # 28
    my $self = shift;
    return $self->{rgd_id};
}

sub get_lsdb
{
    # 29
    my $self = shift;
    return $self->{lsdb};
}

sub get_cosmic
{
    # 30
    my $self = shift;
    return $self->{cosmic};
}

sub get_omim_id
{
    # 31
    my $self = shift;
    return $self->{omim_id};
}

sub get_mirbase
{
    # 32
    my $self = shift;
    return $self->{mirbase};
}

sub get_homeodb
{
    # 33
    my $self = shift;
    return $self->{homeodb};
}

sub get_snornabase
{
    # 34
    my $self = shift;
    return $self->{snornabase};
}

sub get_bioparadigms_slc
{
    # 35
    my $self = shift;
    return $self->{bioparadigms_slc};
}

sub get_orphanet
{
    # 36
    my $self = shift;
    return $self->{orphanet};
}

sub get_pseudogene_id
{
    # 37
    my $self = shift;
    return $self->{pseudogene_id};
}

sub get_horde_id
{
    # 38
    my $self = shift;
    return $self->{horde_id};
}

sub get_merops
{
    # 39
    my $self = shift;
    return $self->{merops};
}

sub get_imgt
{
    # 40
    my $self = shift;
    return $self->{imgt};
}

sub get_iuphar
{
    # 41
    my $self = shift;
    return $self->{iuphar};
}

sub get_kznf_gene_catalog
{
    # 42
    my $self = shift;
    return $self->{kznf_gene_catalog};
}

sub get_mamit_trnadb
{
    # 43
    my $self = shift;
    return $self->{mamit_trnadb};
}

sub get_cd
{
    # 44
    my $self = shift;
    return $self->{cd};
}

sub get_lncrnadb
{
    # 45
    my $self = shift;
    return $self->{lncrnadb};
}

sub get_enzyme_id
{
    # 46
    my $self = shift;
    return $self->{enzyme_id};
}

sub get_intermediate_filament_db
{
    # 47
    my $self = shift;
    return $self->{intermediate_filament_db};
}

sub get_rna_central_ids
{
    # 48
    my $self = shift;
    return $self->{rna_central_ids};
}

sub get_lncipedia
{
    # 49
    my $self = shift;
    return $self->{lncipedia};
}

sub get_gtrnadb
{
    # 50
    my $self = shift;
    return $self->{gtrnadb};
}

sub get_agr
{
    # 51
    my $self = shift;
    return $self->{agr};
}

sub get_mane_select
{
    # 52
    my $self = shift;
    return $self->{mane_select};
}

sub get_gencc
{
    # 53
    my $self = shift;
    return $self->{gencc};
}

1;