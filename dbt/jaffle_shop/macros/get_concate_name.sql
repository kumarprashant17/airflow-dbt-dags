-- macro to concat two string

{% macro concat_name(first_name, last_name) %}
    CONCAT(first_name,' ', last_name)
{% endmacro %}
