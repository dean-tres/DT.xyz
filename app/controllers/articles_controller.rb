# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]
  layout 'base'

  def index
    @articles = Article.all
  end

  def show; end

  private

  def set_article
    # find by permalink or id
    @article = Article.find_by(permalink: article_params[:permalink]) || Article.find_by(id: article_params[:permalink].to_i)

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
