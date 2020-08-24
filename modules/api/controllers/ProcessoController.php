<?php

namespace app\modules\api\controllers;

use Yii;
use yii\helpers\ArrayHelper;
use yii\filters\auth\HttpBearerAuth;
use yii\filters\ContentNegotiator;
use yii\filters\Cors;
use yii\filters\VerbFilter;
use app\modules\api\models\Processo;
use yii\db\Query;

class ProcessoController extends \yii\web\Controller
{
    public function behaviors() {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'index' => ['post'],
                    'detalhe' => ['post'],
                    'create' => ['post'],
                    'update' => ['put'],
//                    'delete' => ['delete'],
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
    
    public function actionIndex()
    {
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        
        try 
        {

            $content = json_decode($request->getRawBody());
            if(isset($content->requerente_id))
            {
                $model = (new Query())
                          ->from('vw_processos')
                          ->where(['=', 'requerente_id', $content->requerente_id])
                          ->all();
                
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
    
    public function actionDetalhe()
    {
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        
        try 
        {

            $content = json_decode($request->getRawBody());
            if(isset($content->id))
            {
                $model = (new Query())
                          ->from('vw_processos')
                          ->where(['=', 'id', $content->id])
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
    
    public function actionCreate() {
        $request = Yii::$app->request;
        $response = Yii::$app->response;

        $model = new Processo();
        $model->attributes = ArrayHelper::toArray(json_decode($request->getRawBody()));
        $model->numero = $model->geraNumero();
        $model->status_id = 1;
        if ($model->save()) {
            
            $response->statusCode = 200;
            return ['id'=>$model->id,'msg' => 'Solicitação criada com sucesso.','processo'=>(int)$model->numero];
        } else {
            $response->statusCode = 400;
           return ['errors' => $model->errors];
        }
    }
    
    public function actionUpdate() {
        
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        try 
        {
            $content = json_decode($request->getRawBody());
            if(isset($content->id))
            {
                $model = $this->findModel($content->id);
                $model->attributes = ArrayHelper::toArray(json_decode($request->getRawBody()));
                if ($model->update()) {

                    $response->statusCode = 200;
                    return $model;
                } else {
                    $response->statusCode = 400;
                   return ['errors' => $model->errors];
                }
                

            }else{
                $response->statusCode = 400;
                return ['errors' => 'Dados Inválidos'];
            }
            
        } catch (\Exception $e) {
            $response->statusCode = 500;
            var_dump($e->getMessage());exit;
            return ['errors' => 'Desculpe Ocorreu um erro!'];
        }

        
    }
    
    protected function findModel($id) {
        if (($model = Processo::findOne($id)) !== null) {
            return $model;
        } 
        return null;
    }

}
