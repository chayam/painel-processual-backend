<?php

namespace app\modules\api\controllers;

use yii\web\Controller;

use yii\filters\auth\HttpBearerAuth;
use yii\filters\ContentNegotiator;
use yii\filters\Cors;
use yii\filters\VerbFilter;
use app\modules\api\models\Requerente;
use yii\helpers\ArrayHelper;
use yii\db\Query;
use Yii;

class RequerenteController extends Controller
{
    public function behaviors() {
        return [
            'verbs' => [
                'class' => VerbFilter::className(),
                'actions' => [
                    'index' => ['get'],
                    'view' => ['get'],
                    'create' => ['post'],
                    'update' => ['put'],
                    'delete' => ['delete'],
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
    
    public function actionIndex() {
        $response = Yii::$app->response;
        $params = $_REQUEST;
        $filter = [];
        $sort = "";

        $page = 1;
        $limit = 10;

        if (isset($params['page']))
            $page = (int) $params['page'];


        if (isset($params['limit']))
            $limit = (int) $params['limit'];

        $offset = $limit * ($page - 1);




        /* Filter elements */
        if (isset($params['filter'])) {
            $filter = (array) json_decode($params['filter']);
        }


        if (isset($params['sort'])) {
            $sort = $params['sort'];
            if (isset($params['order'])) {
                if ($params['order'] == "false")
                    $sort .= " desc";
                else
                    $sort .= " asc";
            }
        }

        $model = (new Query())
                  ->select('*')
                  ->from('vw_requerente')
                  ->offset($offset)
                  ->limit($limit)
                   ->andFilterWhere(['like', 'upper(nome)', isset($filter['nome']) ? '%' . strtoupper($filter['nome']) . '%' : '', false])
                  ->andFilterWhere(['like', 'cpf', isset($filter['cpf']) ? $filter['cpf'] : ''])
                  ->orderBy($sort)
                  ->all();
        
        $models = $model;
        $totalItems = count($model);
        $response->statusCode = 200;
        return ['data' => $models, '_ref' => ['total' => $totalItems,'page'=>$page,'limit'=>$limit]];
    }
    
    public function actionView($id) {
        $response = Yii::$app->response;
        $model = $this->findModelQuery($id);
        
        if($model)
        {
            $response->setStatusCode(200);
            return $model;
            
        }else{
            $response->setStatusCode(404);
            return ['error_code' => $response->getStatusCode(), 'message' => 'Not found'];
        }
    }
    
    public function actionCreate() {
        $request = Yii::$app->request;
        $response = Yii::$app->response;

        $model = new Requerente();
        $model->attributes = ArrayHelper::toArray(json_decode($request->getRawBody()));
        if ($model->save()) {

            $response->statusCode = 200;
            return ['msg'=>'Requerente criado com sucesso!'];
        } else {
            $response->statusCode = 400;
           return ['errors-validation' => $model->errors];
        }
    }
    
    public function actionUpdate($id) {
        $request = Yii::$app->request;
        $response = Yii::$app->response;

        $model = $this->findModel($id);

        $model->attributes = ArrayHelper::toArray(json_decode($request->getRawBody()));

        if ($model->validate()) {
            $response->setStatusCode(200);
            $model->update();
            return $model->attributes;
        } else {
            $response->setStatusCode(400);
            return ['errors' => $model->errors];
        }
    }
    
    public function actionDelete($id) {
        $response = Yii::$app->response;

        $model = $this->findModel($id);

        if ($model->validate()) {
            $response->setStatusCode(200);
            $model->ativo = 0;
            $model->update();
            return $model->id;
        } else {
            $response->setStatusCode(400);
            return ['errors' => $model->errors];
        }
    }
    
    
    protected function findModel($id) {
        if (($model = Requerente::find()->where(['id'=>$id])->ativo()->one()) !== null) {
            return $model;
        } 
        return null;
    }
    
    protected function findModelQuery($id) {
        if (($model = (new Query())->from('vw_requerente')->where(['id'=>$id])->one()) !== null) {
            return $model;
        }
        return null;
    }
}
