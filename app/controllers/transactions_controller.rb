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
# Returns last transactions ordered by months in a year period, separate income and expense... expense on positive values
    def chart_data
        end_date = Transaction.all.last.updated_at
        start_date = Transaction.all.first.updated_at - 1.year
        transactions = Transaction.where(updated_at: start_date.beginning_of_day..end_date.end_of_day).order(updated_at: :asc).group_by { |t| t.updated_at.beginning_of_month }
        monthly_transactions = transactions.transform_values do |entries| {
            income: entries.select {|t| t.value > 0},
            expense: entries.select {|t| t.value < 0}
        }
        end

        @response = monthly_transactions
        if @response
            render json: @response, status: :ok
        else
            render json: @response, status: :unprocessable_entity
        end
    end

    private

    def transaction_params
        params.require(:transaction).permit(:name, :value, :id)
    end
end
