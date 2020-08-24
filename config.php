<?php

$params = require __DIR__ . '/params.php';
$config = [
    'id' => 'micro-backend',
    'sourceLanguage' => 'pt_br',
    'language' => 'pt_br',
    'timeZone' => 'America/Belem',
    'charset' => 'utf-8',
    // the basePath of the application will be the `micro-app` directory
    'basePath' => __DIR__,
    // this is where the application will find all controllers
    'controllerNamespace' => 'micro\controllers',
    // set an alias to enable autoloading of classes from the 'micro' namespace
    'aliases' => [
        '@micro' => __DIR__,
        '@bower' => '@vendor/bower-asset',
    ],
    'components' => [
        'db' => [
            'class' => 'yii\db\Connection',
            'dsn' => 'mysql:host=localhost:3308;dbname=api',
            'username' => 'root',
            'password' => '',
            'charset' => 'utf8',
        ],
        'request' => [
            'enableCsrfValidation' => false,
            'enableCookieValidation' => false,
        ],
        'cache' => [
            'class' => 'yii\caching\FileCache',
        ],
        'session' => [
            'name' => 'micro-backend_session',
        ],
        'user' => [
            'identityClass' => 'app\models\User',
            
        ],
        'urlManager' => [
            'enablePrettyUrl' => true,
            'showScriptName' => false,
            'rules' => [
                'v1/requerente/view/<id:[\w\-]+>'=>'v1/requerente/view',
                'v1/requerente/update/<id:[\w\-]+>'=>'v1/requerente/update',
                'v1/requerente/delete/<id:[\w\-]+>'=>'v1/requerente/delete',
            ],
        ],
    ],
    'modules' => [
        'v1' => [
            'class' => 'app\modules\api\ApiModule',
        ],
    ],
    'params' => $params,
    
];

if (YII_ENV_DEV) {
    // configuration adjustments for 'dev' environment
    $config['bootstrap'][] = 'debug';
    $config['modules']['debug'] = [
        'class' => 'yii\debug\Module',
        // uncomment the following to add your IP if you are not connecting from localhost.
        //'allowedIPs' => ['127.0.0.1', '::1'],
    ];

    $config['bootstrap'][] = 'gii';
    $config['modules']['gii'] = [
        'class' => 'yii\gii\Module',
        // uncomment the following to add your IP if you are not connecting from localhost.
        //'allowedIPs' => ['127.0.0.1', '::1'],
    ];
}

return $config;