class MessagesController < ApplicationController
  # いずれのアクションも「どの会話（チャットルーム）に存在するメッセージなのか？」という情報が必要
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end
  def index
      # indexアクションに書かれたこれらの記載は、
      # 一つ一つの部分で何をしているかの理解をわかりやすくするために
      # このような記載にしていますが、実戦で用いるのには少々冗長なコードとなっているので
      # 余力のある人はコードのリファクタリングにも挑戦してみましょう！
    @messages = @conversation.messages
    if @messages.length > 10
        @over_ten = true
        @messages = Message.where(id: @messages[-10..-1].pluck(:id))
    end
    if params[:m]
        @over_ten = false
        @messages = @conversation.messages
    end
    if @messages.last
        @messages.where.not(user_id: current_user.id).update_all(read: true)
    end
    @messages = @messages.order(:created_at)
    @message = @conversation.messages.build
  end

  def create
    @message = @conversation.messages.build(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    else
      render 'index'
    end
  end

  private
  def message_params
      params.require(:message).permit(:body, :user_id)
  end
end