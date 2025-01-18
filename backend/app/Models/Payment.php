<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    use HasFactory;
    
    protected $fillable = [
        'order_id',
        'transaction_id',
        'amount',
        'payment_method',
        'payment_code',
        'payment_status',
        'transaction_date'
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }
}
