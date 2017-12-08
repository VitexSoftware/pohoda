# Pohoda XML

[![Build Status](https://img.shields.io/travis/VitexSoftware/pohoda/master.svg?style=flat-square)](https://travis-ci.org/vitexsoftware/pohoda)
[![Latest Version](https://img.shields.io/packagist/v/vitexsoftware/pohoda.svg?style=flat-square)](https://packagist.org/packages/vitexsoftware/pohoda)
[![Total Downloads](https://img.shields.io/packagist/dt/vitexsoftware/pohoda.svg?style=flat-square)](https://packagist.org/packages/vitexsoftware/pohoda)
[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square)](LICENSE)


!['Project Logo'](https://raw.githubusercontent.com/VitexSoftware/pohoda/master/phpohoda)

Díky Firmě www.riesenia.com za původní verzi jejich knihovny: https://github.com/riesenia/pohoda ze které tento fork vychází

## Inštalácia

Pridaním do *composer.json*:

```json
{
    "require": {
        "vitexsoftware/pohoda": "1.x-dev"
    }
}
```

## Príklad exportu objednávok

Príklady pre export jednotlivých typov viď. *spec* folder.

```php
use Rshop\Synchronization\Pohoda;

$pohoda = new Pohoda('ICO');

// create file
$pohoda->open($filename, 'Import orders');

// create order
$order = $pohoda->createOrder([
    'numberOrder' => $order_number,
    'isReserved' => true,
    'date' => $created,
    'text' => '...',
    'partnerIdentity' => [
        'address' => [
            'name' => $billing_name,
            'street' => $billing_street,
            'city' => $billing_city,
            'zip' => $billing_zip,
            'email' => $email,
            'phone' => $phone
        ],
        'shipToAddress' => [
            'name' => $shipping_name,
            'street' => $shipping_street,
            'city' => $shipping_city,
            'zip' => $shipping_zip,
            'email' => $email,
            'phone' => $phone
        ]
    ]
]);

// add items
foreach ($items as $item) {
    $order->addItem([
        'code' => $item->code,
        'text' => $item->text,
        'quantity' => $item->quantity,
        'payVAT' => false,
        'rateVAT' => $item->rate,
        'homeCurrency' => [
            'unitPrice' => $item->unit_price
        ],
        'stockItem' => [
            'stockItem' => [
                'id' => $item->pohoda_id
            ]
        ]
    ]);
}

// add summary
$order->addSummary([
    'roundingDocument' => 'none'
]);

// add order to export (identified by $order_number)
$pohoda->addItem($order_number, $order);

// finish export
$pohoda->close();
```

## Príklad importu produktov

Import je riešený jednoducho - vracia *SimpleXMLElement* s danou entitou.

```php
use Rshop\Synchronization\Pohoda;

$pohoda = new Pohoda('ICO');

// load file
$pohoda->loadStock($filename);

while ($stock = $pohoda->next()) {
    // access header
    $header = $stock->children('stk', true)->stockHeader;

    // ...
}
```

## Příklad doplnění externího id do Adresáře

Když je pro import dokladů z externího systému je třeba sloučit již existující položky adresáře a přidat jim externí ID z původního systému

```php
use Rshop\Synchronization\Pohoda;

$pohoda = new Pohoda('ICO');

 $recordData = [
            'identity' => [
                'extId' => [
                    'ids' => $extID,
                    'exSystemName' => 'Číslo zákazníka',
                    'exSystemText' => 'Externí ID z excelu'
                ]
            ]
         ];

$addressBookUpdate = $pohoda->updateAddressbook($recordData, ['company' => htmlspecialchars( 'Novák & Syn s.r.o.' )]);
pohoda->addItem('update adresy', $addressBookUpdate);


```
