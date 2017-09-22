# Parse MrBayes Ancestral States

- 2017-09-22
- Johan.Nylander\@nbis.se

The software MrBayes have the capacity of inferring ancestral character states.
The results are summarized in the `.p` file. This script parses the MrBayes output
and saves the actual states or sequence, with the highest posterior probability
as a fasta file.

**NOTE: beta version - Caveat Emptor**

## Set up MrBayes to do the ancestral reconstructions

Example [dataset](data/mix.nex) with combined DNA and morphological data.
When reading the data, the morphological data are automatically assigned
to a separate partition (number 2). We will define one specific node where
ancestral states should be estimated, then tell MrBayes to report the
ancestral states for all characters in partition 2. The `Lset coding=variable`
command is for accounting for coding bias in the morphological data. See
the MrBayes manual for explanation. Also note that on your data, you might
want to change default settings on substitution models, MCMC, etc.

    #NEXUS
    Begin MrBayes;
        Set autoclose=yes nowarn=yes;
        Execute mix.nex;
        Taxset MyTaxset = Andricus_curvator Andricus_kollari;
        Constraint MyConstraint = MyTaxset;
        Prset topologypr = constraints(MyConstraint);
        Lset applyto=(2) coding=variable;
        Report applyto=(2) ancstates=yes;
        Mcmc nruns=1 nchains=1 ngen=50000 checkpoint=no;
        Sump;
        Quit;
    End;


## Parse the output from MrBayes

Run the script with the `.pstat` file as input. The resulting sequence is written
to standard out, while the details about state probabilities is printed on standard
error.

    ./script.pl data.nex.pstat

or

    ./script.pl data.nex.pstat > ancestral.fas 2> ancestral.txt


## Example 2: Ancestral sequence estimation

Here we will report the ancestral sequence for a specific node in the tree.
We will use an example [file](data/dna.nex) with DNA data.

#### MrBayes commands:

    #NEXUS
    Begin MrBayes;
        Set autoclose=yes nowarn=yes;
        Execute dna.nex;
        Taxset MyTaxset = Andricus_curvator Andricus_kollari;
        Constraint MyConstraint = MyTaxset;
        Prset topologypr = constraints(MyConstraint);
        Report ancstates=yes;
        Mcmc nruns=1 nchains=1 ngen=50000 checkpoint=no;
        Sump;
        Quit;
    End;

#### Run the script:

    ./script.pl dna.nex.pstat


