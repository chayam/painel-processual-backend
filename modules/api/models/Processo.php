<?php

namespace app\modules\api\models;

use Yii;

/**
 * This is the model class for table "processo".
 *
 * @property int $id
 * @property int $requerente_id
 * @property int $usuario_id
 * @property int $assunto_id
 * @property int $status_id
 * @property int $numero
 * @property string $descricao
 * @property string $observacao
 * @property string $dt_criacao
 *
 * @property LogProcesso[] $logProcessos
 * @property Assunto $assunto
 * @property Requerente $requerente
 * @property Status $status
 * @property Usuario $usuario
 */
class Processo extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'processo';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['requerente_id', 'assunto_id', 'status_id', 'numero', 'descricao', 'observacao'], 'required'],
            [['requerente_id', 'usuario_id', 'assunto_id', 'status_id', 'numero'], 'integer'],
            [['observacao'], 'string'],
            [['dt_criacao'], 'safe'],
            [['descricao'], 'string', 'max' => 100],
            //[['assunto_id'], 'exist', 'skipOnError' => true, 'targetClass' => Assunto::className(), 'targetAttribute' => ['assunto_id' => 'id']],
            //[['requerente_id'], 'exist', 'skipOnError' => true, 'targetClass' => Requerente::className(), 'targetAttribute' => ['requerente_id' => 'id']],
            //[['status_id'], 'exist', 'skipOnError' => true, 'targetClass' => Status::className(), 'targetAttribute' => ['status_id' => 'id']],
            //[['usuario_id'], 'exist', 'skipOnError' => true, 'targetClass' => Usuario::className(), 'targetAttribute' => ['usuario_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'requerente_id' => 'Requerente ID',
            'usuario_id' => 'Usuario ID',
            'assunto_id' => 'Assunto ID',
            'status_id' => 'Status ID',
            'numero' => 'Numero',
            'descricao' => 'Descricao',
            'observacao' => 'Observacao',
            'dt_criacao' => 'Dt Criacao',
        ];
    }
    
    public function geraNumero()
    {
        $model = Processo::find();
        $numero = date("Y").($model->count()+1);
        return $numero;
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getLogProcessos()
    {
        return $this->hasMany(LogProcesso::className(), ['processo_id' => 'id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getAssunto()
    {
        return $this->hasOne(Assunto::className(), ['id' => 'assunto_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getRequerente()
    {
        return $this->hasOne(Requerente::className(), ['id' => 'requerente_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getStatus()
    {
        return $this->hasOne(Status::className(), ['id' => 'status_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getUsuario()
    {
        return $this->hasOne(Usuario::className(), ['id' => 'usuario_id']);
    }
}
