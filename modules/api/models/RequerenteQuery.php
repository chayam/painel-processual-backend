<?php

namespace app\modules\api\models;

/**
 * This is the ActiveQuery class for [[Requerente]].
 *
 * @see Requerente
 */
class RequerenteQuery extends \yii\db\ActiveQuery
{
    public function ativo()
    {
        return $this->andWhere(['ativo'=>1]);
    }

    /**
     * {@inheritdoc}
     * @return Requerente[]|array
     */
    public function all($db = null)
    {
        return parent::all($db);
    }

    /**
     * {@inheritdoc}
     * @return Requerente|array|null
     */
    public function one($db = null)
    {
        return parent::one($db);
    }
}
