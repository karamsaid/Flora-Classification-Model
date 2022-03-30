SELECT 
    `c`.`customer_id`,
    `inv`.`invoice_id`,
    IF(`o`.`occupation` = '?',
        'NaN',
        `o`.`occupation`) AS `Occupation`,
    IF(`et`.`employment_type` = '?',
        'Nan',
        `et`.`employment_type`) AS `Employment Type`,
    IF(`tcs`.`type_of_client` IS NULL,
        'NaN',
        `tcs`.`type_of_client`) AS `Type of Client`,
    SUM(`inv`.`quantity` > 0) AS `Total quantity per invoice`,
    AVG(`inv`.`unit_price`) AS `Average Unit Price`,
    (SUM(`inv`.`quantity` > 0)) * (AVG(`inv`.`unit_price`)) AS `Total Revenue per Invoice`,
    IF((SUM(`inv`.`quantity` > 0) ) > 5,
        'YES',
        'No') AS `> 5  units`
FROM
    `H_Retail`.`customer` AS `c`
        INNER JOIN
    `H_Retail`.`occupation` AS `o` ON `c`.`occupation_id` = `o`.`occupation_id`
        INNER JOIN
    `H_Retail`.`employment_type` AS `et` ON `c`.`employment_type_id` = `et`.`employment_type_id`
        LEFT JOIN
    `H_Retail`.`type_of_client_staging2` AS `tcs` ON `c`.`customer_id` = `tcs`.`customer_id`
        INNER JOIN
    (SELECT 
        `i`.`customer_id`,
            `il`.`quantity`,
            `il`.`invoice_id`,
            `il`.`product_id`,
            `il`.`unit_price`
    FROM
        `H_Retail`.`invoice2` AS `i`
    INNER JOIN `H_Retail`.`invoice_line` AS `il` ON `i`.`invoice_id` = `il`.`invoice_id`
    ORDER BY `i`.`customer_id`) AS `inv` ON `c`.`customer_id` = `inv`.`customer_id`
WHERE
    `c`.`customer_id` <> 0
GROUP BY `inv`.`invoice_id`
ORDER BY customer_id ASC