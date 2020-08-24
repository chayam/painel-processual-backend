<?php

namespace micro\controllers;

use yii\filters\auth\HttpBearerAuth;
use yii\filters\ContentNegotiator;
use yii\filters\Cors;
use yii\web\Controller;
use yii\filters\VerbFilter;
use app\models\Processo;
use yii\helpers\ArrayHelper;
use Yii;

class ProcessoController extends Controller
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

        $model = Processo::find();
        $model->offset($offset)
                ->limit($limit)
                ->orderBy($sort);

        $models = $model->asArray()->all();
        $totalItems = count($model->all());
        $response->statusCode = 200;
        return ['data' => $models, '_ref' => ['total' => $totalItems,'page'=>$page,'limit'=>$limit]];
    }
    
    public function actionCreate() {
        $request = Yii::$app->request;
        $response = Yii::$app->response;

        $model = new Processo();
        $model->numero = $model->geraNumero();
        $model->status_id = 1;
        $model->ano = date('Y');
        $model->attributes = ArrayHelper::toArray(json_decode($request->getRawBody()));
        if ($model->save()) {

            $response->statusCode = 200;
            return ['msg' => 'Solicitação criada com sucesso.','processo'=>(int)$model->numero];
        } else {
            $response->statusCode = 400;
           return ['errors' => $model->errors];
        }
    }
    
    protected function findModel($id) {
        if (($model = Processo::findOne($id)) !== null) {
            return $model;
        } 
        return null;
    }
}
