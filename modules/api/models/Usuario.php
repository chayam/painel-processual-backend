<?php

namespace app\modules\api\models;

use Yii;

/**
 * This is the model class for table "usuario".
 *
 * @property int $id
 * @property int $perfil_id
 * @property int $setor_id
 * @property string $nome
 * @property string $email
 * @property int $matricula
 * @property string $senha
 * @property int $ativo
 * @property string $dt_criacao
 *
 * @property Processo[] $processos
 * @property Perfil $perfil
 * @property Setor $setor
 */
class Usuario extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'usuario';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['perfil_id', 'setor_id', 'nome', 'email', 'matricula', 'senha'], 'required'],
            [['perfil_id', 'setor_id', 'matricula', 'ativo'], 'integer'],
            [['dt_criacao'], 'safe'],
            [['nome', 'email', 'senha'], 'string', 'max' => 100],
            [['perfil_id'], 'exist', 'skipOnError' => true, 'targetClass' => Perfil::className(), 'targetAttribute' => ['perfil_id' => 'id']],
            [['setor_id'], 'exist', 'skipOnError' => true, 'targetClass' => Setor::className(), 'targetAttribute' => ['setor_id' => 'id']],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'perfil_id' => 'Perfil ID',
            'setor_id' => 'Setor ID',
            'nome' => 'Nome',
            'email' => 'Email',
            'matricula' => 'Matricula',
            'senha' => 'Senha',
            'ativo' => 'Ativo',
            'dt_criacao' => 'Dt Criacao',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getProcessos()
    {
        return $this->hasMany(Processo::className(), ['usuario_id' => 'id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getPerfil()
    {
        return $this->hasOne(Perfil::className(), ['id' => 'perfil_id']);
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getSetor()
    {
        return $this->hasOne(Setor::className(), ['id' => 'setor_id']);
    }
}
