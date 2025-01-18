<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('address_id');
            $table->decimal('total_price', 10, 2)->default(0);
            $table->enum('status', ['unpaid', 'pending', 'confirmed', 'delivered', 'completed', 'canceled'])->default('unpaid');
            $table->timestamp('tgl_pesan')->useCurrent();
            $table->dateTime('tgl_antar');
            $table->time('jam');
            $table->text('catatan')->nullable();
            $table->string('snap_token')->nullable();
            $table->enum('transaction_status', ['pending', 'settlement', 'cancel', 'deny', 'expire', 'failure'])->default('pending');
            $table->string('payment_method')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('address_id')->references('id')->on('addresses')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('orders');
    }
};
