#configfile: "config.yaml"
include: "snakefiles/rbc_mapper.rules.smk"

rule all:
    input:
         rules.testing.input,
