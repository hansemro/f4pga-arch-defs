add_file_target(FILE ntemplate.icapN.model.xml SCANNER_TYPE xml)
add_file_target(FILE ntemplate.icapN.pb_type.xml SCANNER_TYPE xml)

n_template(
    NAME icapN.pb_type.xml
    PREFIXES 0;1
    SRCS ntemplate.icapN.pb_type.xml
    )
n_template(
    NAME icapN.model.xml
    PREFIXES 0;1
    SRCS ntemplate.icapN.model.xml
    )
