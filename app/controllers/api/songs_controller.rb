class Api::SongsController < ApplicationController
  def index
    if params[:query] == "alphabetical"
      @songs = Song
                  .order(:title, :artist)
    elsif params[:query]
      @songs = Song
                  .where(
                    "LOWER(title) ~ :query OR LOWER(artist) ~ :query",
                    query: params[:query].downcase
                  ).order(:title, :artist)
    else
      # Upgrade this to select top 10 songs by upvotes
      @songs = Song
                .select('
                    songs.*,
                    sum(votes.vote) as score')
                .joins(:votes)
                .group("songs.id")
                .order("score DESC")
                .limit(9)
    end
  end

  def create
    @song = Song.new(song_params)
    if @song.save
      render :create
    else
      render json: @song.errors, status: 422
    end
  end

  def update
    @song = Song.find(params[:id])
    @song.update(song_params)
    if @song.save
      render :show
    else
      render json: {"message": "unable to update"}, status: 422
    end
  end

  def show
    @song = Song.includes(
        :comments,
        :votes,
        comments: [:author, :votes])
      .find(params[:id])
  end

  private
  def song_params
    params.require(:song).permit(
      :artist,
      :title,
      :lyrics,
      :youtube_url,
      :soundcloud_url,
      :featuring,
      :produced_by,
      :written_by,
      :release_date,
      :about,
      :album_cover
    )
  end
end
