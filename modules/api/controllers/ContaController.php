<?php

namespace app\modules\api\controllers;

use yii\filters\auth\HttpBearerAuth;
use yii\filters\ContentNegotiator;
use yii\filters\Cors;
use yii\filters\VerbFilter;
use yii\db\Query;
use Yii;

class ContaController extends \yii\web\Controller
{
    public function behaviors() {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'login' => ['post'],
                    'Identity' => ['post'],
                    'user' => ['post'],
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
    
    public function actionLogin()
    {
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        
        try 
        {

            $content = json_decode($request->getRawBody());
            if(isset($content->cpf) && isset($content->senha))
            {
                $model = (new Query())
                          ->from('vw_requerente')
                          ->andFilterWhere(['=', 'cpf', $content->cpf])
                          ->one();
                if($model && Yii::$app->getSecurity()->validatePassword($content->senha, $model['senha']))
                {
                    return $model;
                }else{
                    $response->statusCode = 400;
                    return ['errors' => 'Credenciais inválidas'];
                }
                
                
            }else{
                $response->statusCode = 400;
                return ['errors' => 'Dados Inválidos'];
            }
            
        } catch (\yii\base\Exception $e) {
            $response->statusCode = 500;
            return ['errors' => 'Desculpe Ocorreu um erro!'];
            
        }
        
    }
    
    public function actionLogin2()
    {
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        
        try 
        {

            $content = json_decode($request->getRawBody());
            if(isset($content->cpf) && isset($content->senha))
            {
                $model = (new Query())
                          ->from('vw_requerente')
                          ->andFilterWhere(['=', 'cpf', $content->cpf])
                          ->one();
                if($model && Yii::$app->getSecurity()->validatePassword($content->senha, $model['senha']))
                {
                    return $model;
                }else{
                    $response->statusCode = 400;
                    return ['Credenciais inválidas'];
                }
                
                
            }else{
                $response->statusCode = 400;
                return ['errors' => 'Dados Inválidos'];
            }
            
        } catch (\yii\base\Exception $e) {
            $response->statusCode = 500;
            return ['errors' => 'Desculpe Ocorreu um erro!'];
            
        }
        
    }
    
    public function actionIdentity()
    {
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        
        try 
        {

            $content = json_decode($request->getRawBody());
            if(isset($content->id))
            {
                $model = (new Query())
                          ->from('vw_requerente')
                          ->andFilterWhere(['=', 'id', $content->id])
                          ->one();
                if(!empty($model))
                {
                    return $model;
                }else{
                    $response->statusCode = 400;
                    return ['errors' => 'Credenciais inválidas'];
                }
                
                
            }else{
                $response->statusCode = 400;
                return ['errors' => 'Dados Inválidos'];
            }
            
        } catch (\yii\base\Exception $e) {
            $response->statusCode = 500;
            return ['errors' => 'Desculpe Ocorreu um erro!'];
            
        }
        
    }
    
    public function actionUser()
    {
        $request = Yii::$app->request;
        $response = Yii::$app->response;
        
        try 
        {

            $content = json_decode($request->getRawBody());
            if(isset($content->cpf))
            {
                $model = (new Query())
                          ->from('vw_requerente')
                          ->andFilterWhere(['=', 'cpf', $content->cpf])
                          ->one();
                if(!empty($model))
                {
                    return $model;
                }else{
                    $response->statusCode = 400;
                    return ['errors' => 'Credenciais inválidas'];
                }
                
                
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
