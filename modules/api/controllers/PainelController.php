<?php

namespace app\modules\api\controllers;

use yii\filters\auth\HttpBearerAuth;
use yii\filters\ContentNegotiator;
use yii\filters\Cors;
use yii\filters\VerbFilter;
use yii\db\Query;
use Yii;

class PainelController extends \yii\web\Controller
{
    public function behaviors() {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'requerente-processo' => ['post'],
                    'requerente-assunto' => ['post'],
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
    
    public function actionRequerenteProcesso()
    {
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        
        try 
        {

            $content = json_decode($request->getRawBody());
            if(isset($content->requerente_id))
            {
                $model = (new Query())
                          ->from('vw_painel_qtd')
                          ->andFilterWhere(['=', 'requerente_id', $content->requerente_id])
                          ->one();
                
                return $model;
                
            }else{
                $response->statusCode = 400;
                return ['errors' => 'Dados Inválidos'];
            }
            
        } catch (\Exception $e) {
            $response->statusCode = 500;
            return ['errors' => 'Desculpe Ocorreu um erro!'];
            
        }
        
    }
    
    public function actionRequerenteAssunto()
    {
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        
        try 
        {

            $content = json_decode($request->getRawBody());
            if(isset($content->requerente_id))
            {
                $model = (new Query())
                          ->from('vw_painel_assunto_qtd')
                          ->andFilterWhere(['=', 'requerente_id', $content->requerente_id])
                          ->one();
                
                return $model;
                
            }else{
                $response->statusCode = 400;
                return ['errors' => 'Dados Inválidos'];
            }
            
        } catch (\yii\base\Exception $e) {
            $response->statusCode = 500;
            return ['errors' => 'Desculpe Ocorreu um erro!'];
            
        }
        
    }
    
    public function actionRequerenteAno()
    {
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        
        try 
        {

            $content = json_decode($request->getRawBody());
            if(isset($content->requerente_id))
            {
                $model = (new Query())
                          ->from('vw_painel_req_proc_ano')
                          ->andFilterWhere(['=', 'requerente_id', $content->requerente_id])
                          ->one();
                
                return $model;
                
            }else{
                $response->statusCode = 400;
                return ['errors' => 'Dados Inválidos'];
            }
            
        } catch (\yii\base\Exception $e) {
            $response->statusCode = 500;
            return ['errors' => 'Desculpe Ocorreu um erro!'];
            
        }
        
    }

}
