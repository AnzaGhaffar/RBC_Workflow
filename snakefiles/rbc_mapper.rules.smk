configfile: "config.yaml"

rule rbc_mapper_complete:
    input: 
       # expand("filtered_vcf_output/filtered_{vcf_file_name}.vcf", vcf_file_name=config["vcf_file"]),
        expand("RBCI_Files/{vcf_file_name}.rbci",vcf_file_name=config["vcf_file"]),
        expand("Output/{chrom_name}.{ext}", chrom_name=config["chromosomes"], ext=["png"])

rule testing:
    input:
        rules.rbc_mapper_complete.input


rule VCF_Filter:
    input:
        expand("{vcf_file_name}.vcf",vcf_file_name=config["vcf_file"])
    output:
        "filtered_vcf_output/filtered_{vcf_file_name}.vcf"
    params:
        filter_data=config["vcffilter"]["filters"].replace('\n',' ')
    shell:
        "( bcftools view"
        "   {params.filter_data}"
        "   {input}"
        "   -O u"
        "   -o {output}"
        ")"

rule generate_rbci:
    input:
        expand("vcf/{vcf_file_name}.vcf",vcf_file_name=config["vcf_file"])
    output:
        "RBCI_Files/{vcf_file_name}.rbci"
    params:
        filter=config["perl_rbci"].replace('\n',' ')
    shell:
        "perl rbc-parser/vcf_2_rbci.2nd_freebayes.pl --vcf {input} {params.filter}> {output}"

#rule rbc_mapper:
#    input:
#        "mapper_test.rbci"
#    output:
#        "mapper_test/chrom_9311chr07.csv",
#    params:
#        filter=config["rbc_mapper"].replace('\n',' ')
#    shell:
#        "python rbc_mapper/rbc_mapper_vienna_Anza.py --file {input} {params.filter} "


rule rbc_mapper:
    input:
      expand("RBCI_Files/{vcf_file_name}.rbci",vcf_file_name=config["vcf_file"])
    output:
        "Output/{chrom_name}.{ext}"
    params:
        filter=config["rbc_mapper"].replace('\n',' ')
    shell:
        "python rbc_mapper/rbc_mapper_vienna_Anza.py --file {input} {params.filter} "
