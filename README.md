# Parse MrBayes Ancestral States

The software MrBayes have the capacity of inferring ancestral character states.
The results are summarized in the `.p` file. This script parses the MrBayes output
and saves the actual states or sequence, with the highest posterior probability
as a fasta file. **also fastq with probs as ascii?**

## Set up MrBayes to do the ancestral reconstructions

Example [dataset](data/mix.nex) with combined DNA and morphological data.
When reading the data, the morphological data are automatically assigned
to a separate partition (number 2). We will define one specific node where
ancestral states should be estimated, then tell MrBayes to report the
ancestral states for all characters in partition 2. The `Lset coding=variable`
command is for accounting for coding bias in the morphological data. See
the MrBayes manual for explanation.

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

Run the script with the `.pstat` file as input. The result is written
to standard out.

    ./script.pl data.nex.pstat


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


## Notes

For plotting sequence with heatmap-highlighted letters in R:
- for each position: read letters with probabilities
- set up a plotting area dependent on the length of the string
- foreach position
- get a heatmap based on the numerical interval 0-1 (see colorRamp)
- create a function that returns a color based on the heatmap and the numerical value
- plot the letter (using some function) with bg given by the above function
- increase x coordinate

Some code:

    library(plotrix)
    library(RColorBrewer)
    library(heatmap2)
    plot(1)
    boxed.labels(0.50,0.5,"A",bg="yellow",border=NA)
    boxed.labels(0.52,0.5,"B",bg="green",border=NA)
    boxed.labels(0.54,0.5,"C",bg="yellow",border=NA)
    boxed.labels(0.56,0.5,"D",bg="green",border=NA)
    boxed.labels(0.58,0.5,"E",bg="yellow",border=NA)


