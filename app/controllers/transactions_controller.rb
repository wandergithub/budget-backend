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
        @id = params.require(:id)
        @transaction = Transaction.find(@id)
        if @transaction.destroy!
            render status: :ok
        else
            render status: :bad_request
        end
    end

    private

    def transaction_params
        params.require(:transaction).permit(:name, :value)
    end
end
