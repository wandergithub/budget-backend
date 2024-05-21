class TransactionsController < ApplicationController
    def index
        @transactions = Transaction.all
        render json: @transactions
    end

    def create
        @transaction = Transaction.new(transaction_params)
        if @transaction.save
            render json: @transaction, status: :created
        else
            render json: @transaction.errors, status: :unprocessable_entity
        end
    end

    def destroy
        user_id = params.require(:id)
        @transaction = Transaction.find(user_id)
        if @transaction.destroy!
            render status: :ok
        else
            render json: @transaction.errors, status: :bad_request
        end
    end

    def update
        @transaction = Transaction.find(transaction_params[:id])
        if @transaction.update(name: transaction_params[:name], value: transaction_params[:value])
            render json: @transaction, status: :created
        else
            render json: @transaction.errors, status: :unprocessable_entity
        end
    end

    private

    def transaction_params
        params.require(:transaction).permit(:name, :value, :id)
    end
end
