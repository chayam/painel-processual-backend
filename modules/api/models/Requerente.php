<?php

namespace app\modules\api\models;

use Yii;
use yiibr\brvalidator\CpfValidator;

/**
 * This is the model class for table "requerente".
 *
 * @property int $id
 * @property string $nome
 * @property string $cpf
 * @property string $telefone
 * @property string $email
 * @property string $dt_aniversario
 * @property string $dt_criacao
 * @property int $ativo
 * @property string $senha
 *
 * @property Processo[] $processos
 */
class Requerente extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'requerente';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['nome', 'cpf', 'email','senha'], 'required'],
            [['cpf','email'], 'unique', 'message' => '"{attribute}" já é utilizado por outro usuário.','filter' => ['ativo'=>1]],
            ['email', 'email'],
            ['cpf', CpfValidator::className(),'message' =>'"{attribute}" é inválido'],
            //['cpf', 'unique', 'filter' => ['ativo'=>1],'message'=>utf8_encode('CPF já cadastrado')],
            [['ativo'], 'integer'],
            [['dt_aniversario'], 'date', 'format' => 'yyyy-MM-dd'],
            [['nome', 'email'], 'string', 'max' => 100],
            [['cpf'], 'string', 'max' => 11],
            [['telefone'], 'string', 'max' => 14],
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function attributeLabels()
    {
        return [
            'id' => 'ID',
            'nome' => 'Nome',
            'cpf' => 'Cpf',
            'telefone' => 'Telefone',
            'email' => 'Email',
            'dt_aniversario' => 'Dt Aniversario',
            'dt_criacao' => 'Dt Criacao',
            'ativo' => 'Ativo',
            'senha' => 'Senha',
        ];
    }
    
    /** 
    * {@inheritdoc} 
    * @return RequerenteQuery the active query used by this AR class. 
    */ 
   public static function find() 
   { 
       return new RequerenteQuery(get_called_class()); 
   } 

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getProcessos()
    {
        return $this->hasMany(Processo::className(), ['requerente_id' => 'id']);
    }
    
    
    public function afterValidate()
    {
        $this->senha = Yii::$app->security->generatePasswordHash($this->senha);
    }
    
}
