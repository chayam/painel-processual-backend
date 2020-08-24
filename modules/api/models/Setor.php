<?php

namespace app\modules\api\models;

use Yii;

/**
 * This is the model class for table "setor".
 *
 * @property int $id
 * @property string $nome
 * @property int $ativo
 *
 * @property Usuario[] $usuarios
 */
class Setor extends \yii\db\ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'setor';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['nome'], 'required'],
            [['ativo'], 'integer'],
            [['nome'], 'string', 'max' => 45],
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
            'ativo' => 'Ativo',
        ];
    }

    /**
     * @return \yii\db\ActiveQuery
     */
    public function getUsuarios()
    {
        return $this->hasMany(Usuario::className(), ['setor_id' => 'id']);
    }
}
