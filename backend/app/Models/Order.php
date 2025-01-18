<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Order extends Model
{
    use HasFactory;
    
    protected $fillable = [
        'user_id',
        'address_id',
        'total_price',
        'status',
        'tgl_pesan',
        'tgl_antar',
        'jam',
        'catatan',
        'snap_token',
        'transaction_status',
        'payment_method'
    ];

    public function user()
    {
        return $this->belongsTo(User::class)->withTrashed();
    }

    public function address()
    {
        return $this->belongsTo(Address::class);
    }

    public function payments()
    {
        return $this->hasMany(Payment::class);
    }

    public function products()
    {
        return $this->belongsToMany(Product::class, 'order_items')->withPivot('jumlah', 'harga')->withTimestamps();
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }
}
