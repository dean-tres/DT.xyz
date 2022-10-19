# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  layout false

  def index
    @articles = Article.all
  end

  def show; end

  private

  def set_article
    @article = Article.find_by(permalink: article_params[:permalink])
    article_not_found if @article.nil?
  end

  def article_not_found
    flash.now[:alert] = 'couldnt find that article :('
    index
    render action: :index
  end

  def article_params
    params.permit(:permalink)
  end
end
