<?php

namespace micro\controllers;

use yii\filters\auth\HttpBearerAuth;
use yii\filters\ContentNegotiator;
use yii\filters\Cors;
use yii\web\Controller;
use yii\filters\VerbFilter;
use app\models\Usuario;
use yii\helpers\ArrayHelper;
use Yii;

/**
 * Usuario controller for the `api` module
 */
class UsuarioController extends Controller {
    /* Declare methods supported by APIs */

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

    /**
     * Lists all User models.
     * @return mixed
     */
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

        $model = Usuario::find();
        $model->offset($offset)
                ->innerJoin('perfil', 'perfil.id = usuario.perfil_id')
                ->innerJoin('setor', 'setor.id = usuario.setor_id')
                ->limit($limit)
                ->andFilterWhere(['like', 'upper(nome)', isset($filter['nome']) ? '%' . strtoupper($filter['nome']) . '%' : '', false])
                ->andFilterWhere(['like', 'cpf', isset($filter['cpf']) ? $filter['cpf'] : ''])
                ->orderBy($sort)
                ->select([
                    'usuario.id',
                    'setor.nome setor',
                    'perfil.nome perfil',
                    'usuario.nome',
                    'usuario.cpf',
                    'usuario.telefone',
                    'DATE_FORMAT(usuario.dt_aniversario, "%d-%m-%Y") dt_aniversario',
        ]);

        $models = $model->asArray()->all();
        $totalItems = count($model->all());
        $response->statusCode = 200;
        echo json_encode(['data' => $models, '_ref' => ['total' => $totalItems,'page'=>$page,'limit'=>$limit]]);
        exit;
    }

    /**
     * Displays a single User model.
     * @param integer $id
     * @return mixed
     */
    public function actionView($id) {
        $response = Yii::$app->response;
        $model = $this->findModel($id);
        if(count($model))
        {
            $response->setStatusCode(200);
            return $model->attributes;
            
        }else{
            $response->setStatusCode(404);
            return ['error_code' => $response->getStatusCode(), 'message' => 'Not found'];
        }
        exit;
    }

    public function actionCreate() {
        $request = Yii::$app->request;
        $response = Yii::$app->response;

        $model = new Usuario();
        $model->attributes = ArrayHelper::toArray(json_decode($request->getRawBody()));
        if ($model->save()) {

            $response->statusCode = 200;
            return true;
        } else {
            $response->statusCode = 400;
           return ['errors' => $model->errors];
        }
    }

    /**
     * Updates an existing User model.
     * @param integer $id
     * @return json
     */
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

    /**
     * Deletes an existing User model.
     * @param integer $id
     * @return json
     */
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

    /**
     * Finds the User model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     * @param integer $id
     * @return User the loaded model
     */
    protected function findModel($id) {
        if (($model = Usuario::findOne($id)) !== null) {
            return $model;
        } 
        return null;
        
    }

}
