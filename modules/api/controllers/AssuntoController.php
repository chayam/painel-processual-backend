<?php

namespace app\modules\api\controllers;

use yii\filters\auth\HttpBearerAuth;
use yii\filters\ContentNegotiator;
use yii\filters\Cors;
use yii\filters\VerbFilter;
use yii\db\Query;
use Yii;

class AssuntoController extends \yii\web\Controller
{
    public function behaviors() {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'lista' => ['get'],
                ],
            ],
            'contentNegotiator' => [
                'class' => ContentNegotiator::className(),
                'formats' => [
                    'application/json' => \yii\web\Response::FORMAT_JSON,
                ],
            ],
            'authenticator' => [
                'class' => HttpBearerAuth::className(),
                'except' => ['options'],
            ],
            'corsFilter' => [
                'class' => Cors::className(),
            ]
        ];
    }
    
    public function actionLista()
    {
        $response = Yii::$app->response;
        
        try 
        {
            
            $model = (new Query())
                      ->from('assunto')
                      ->all();
            
            if(empty($model)){
                $response->statusCode = 404;
            return ['errors' => 'Não há dados!'];
            }

            return $model;
            
            
        } catch (\yii\base\Exception $e) {
            $response->statusCode = 500;
            return ['errors' => 'Desculpe Ocorreu um erro!'];
            
        }
        
    }
    
}
