# Improvements

## Reading

Convert the CamelCase JSON field names to more Ruby-like snake_case fields.

Ex: shortName => short_name

## API Structure

Have a look to Stripe API to use the objects themselves as starting point:

    data_elements = DataElement.list(filter: "...", fields: [...])
    data_element = DataElement.find(id)

This would make the "write/update" API better:

    DataElement.create(name: "", short_name: "")