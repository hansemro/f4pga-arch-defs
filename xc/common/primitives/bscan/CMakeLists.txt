add_file_target(FILE ntemplate.bscanN.model.xml SCANNER_TYPE xml)
add_file_target(FILE ntemplate.bscanN.pb_type.xml SCANNER_TYPE xml)

n_template(
    NAME bscanN.pb_type.xml
    PREFIXES 0;1;2;3
    SRCS ntemplate.bscanN.pb_type.xml
    )
n_template(
    NAME bscanN.model.xml
    PREFIXES 0;1;2;3
    SRCS ntemplate.bscanN.model.xml
    )
