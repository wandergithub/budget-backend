class TransactionsController < ApplicationController
    def index
        @transactions = Transaction.all.order(updated_at: :desc)
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
# [
#   {
#     "month": 5, month number 1-12
#     "income": 37709, --> total inconme on the month
#     "expense": 84453 --> total expense on the month
#   }
# ]
    def chart_data
        end_date = Transaction.last.created_at
        start_date = Transaction.first.created_at

        transactions = Transaction.where(updated_at: start_date.beginning_of_day..end_date.end_of_day).order(updated_at: :asc).group_by { |t| t.updated_at.beginning_of_month }

        months = []
        current_date = start_date.beginning_of_month

        while current_date <= end_date.beginning_of_month
          months << current_date
          current_date = current_date.next_month
        end

        monthly_summaries = months.map do |month|
            entries = transactions[month] || []
            income = entries.select { |t| t.value > 0 }.sum(&:value)
            expense = entries.select { |t| t.value < 0 }.sum(&:value).abs
            { month: month.month, income: income, expense: expense }
        end
        
        @response = monthly_summaries
        if @response
            render json: @response, status: :ok
        else
            render json: @response, status: :unprocessable_entity
        end
    end
#returns last month and prev month transactions taking the current date as starting point
    def month
        last_month = Transaction.where(updated_at: (Date.today - 1.month).beginning_of_day..Date.today.end_of_day)
        prev_month = Transaction.where(updated_at: (Date.today - 2.month).beginning_of_day..(Date.today - 1.month).beginning_of_day)
        @response = {last: last_month, prev: prev_month}
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
