defmodule Auctoritas.DataStorage do
  @moduledoc """
  DataStorage module
  * Specifies `DataStorage` behaviour
  """

  @typedoc "Authentication token"
  @type token() :: String.t()

  @typedoc "Name from config (Auctoritas supervisor name)"
  @type name() :: String.t()

  @typedoc "Token expiration in seconds"
  @type expiration() :: non_neg_integer()

  alias Auctoritas.DataStorage.Data
  alias Auctoritas.DataStorage.RefreshTokenData

  @doc """
  Starts data_storage when returned `{:ok, worker_map_or_equals}`
  Return `{:no_worker}` if data_storage startup isn't required
  """
  @callback start_link(map()) :: {:ok, list()} | {:no_worker}

  @doc """
  Insert token with expiration and supplied data map.
  """
  @callback insert_token(
              name(),
              token_expiration :: expiration(),
              token :: token(),
              token_data :: map()
            ) :: {:ok, token(), %Data{}} | {:error, error :: any()}

  @callback insert_token(
              name(),
              token_expiration :: expiration(),
              token :: token(),
              refresh_token :: token(),
              token_data :: map()
            ) :: {:ok, token(), %Data{}} | {:error, error :: any()}

  @callback insert_refresh_token(
              name(),
              refresh_token_expiration :: expiration(),
              refresh_token :: token(),
              token :: token(),
              auth_data :: map()
            ) :: {:ok, token(), %RefreshTokenData{}} | {:error, error :: any()}

  @callback reset_expiration(name(), token :: token(), expiration()) :: {atom(), any()}

  @doc """
  Delete token from data_storage, used when deauthenticating (logging out)
  """
  @callback delete_token(name(), token :: token()) :: {atom(), any()} :: {:ok, boolean()} | {:error, error :: any()}

  @callback delete_refresh_token(name(), refresh_token :: token()) ::
              {atom(), any()} :: {:ok, boolean()} | {:error, error :: any()}

  @callback get_token_data(name(), token :: token()) :: {:ok, %Data{}} | {:error, error :: any()}
  @callback get_refresh_token_data(name(), refresh_token :: token()) ::
              {:ok, %RefreshTokenData{}} | {:error, error :: any()}

  @doc """
  Return tokens with specified start and amount value
  """
  @callback get_tokens(name(), start :: non_neg_integer(), amount :: non_neg_integer()) ::
              {:ok, list(token())} | {:error, error :: any()}

  @doc """
  Return refresh tokens with specified start and amount value
  """
  @callback get_refresh_tokens(name(), start :: non_neg_integer(), amount :: non_neg_integer()) ::
              {:ok, list(token())} | {:error, error :: any()}

  @doc """
  Return token expiration time in seconds
  """
  @callback token_expires?(name(), token()) :: {:ok, expiration()} | {:error, error :: any()}
end
