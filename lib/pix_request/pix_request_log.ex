defmodule StarkInfra.PixRequest.Log do
  alias __MODULE__, as: Log
  alias StarkInfra.Utils.Rest
  alias StarkInfra.Utils.API
  alias StarkInfra.Utils.Check
  alias StarkInfra.PixRequest
  alias StarkInfra.User.Project
  alias StarkInfra.User.Organization
  alias StarkInfra.Error

  @moduledoc """
  Groups PixRequest.Log related functions
  """

  @doc """
  Every time a PixRequest entity is modified, a corresponding PixRequest.Log
  is generated for the entity. This log is never generated by the user.

  ## Attributes:
    - `:id` [string]: unique id returned when the log is created. ex: "5656565656565656"
    - `:created` [DateTime]: creation datetime for the log. ex: ~U[2020-3-10 10:30:0:0]
    - `:type` [string]: type of the PixRequest event which triggered the log creation. Options: “sent”, “denied”, “failed”, “created”, “success”, “approved”, “credited”, “refunded”, “processing”.
    - `:errors` [list of strings]: list of errors linked to this PixRequest event
    - `:request` [PixRequest]: PixRequest entity to which the log refers to.
  """
  @enforce_keys [
    :id,
    :created,
    :type,
    :errors,
    :request
  ]
  defstruct [
    :id,
    :created,
    :type,
    :errors,
    :request
  ]

  @type t() :: %__MODULE__{}

  @doc """
  Receive a single PixRequest.Log struct previously created by the Stark Infra API by its id

  ## Parameters (required):
    - `:id` [string]: struct unique id. ex: "5656565656565656"

  ## Options:
    - `:user` [Organization/Project, default nil]: Organization or Project struct returned from StarkInfra.project(). Only necessary if default project or organization has not been set in configs.

  ## Return:
    - PixRequest.Log struct with updated attributes
  """
  @spec get(
    id: binary,
    user: Project.t() | Organization.t() | nil
  ) ::
    {:ok, Log.t()} |
    {:error, [Error.t()]}
  def get(id, options \\ []) do
    Rest.get_id(resource(), id, options)
  end

  @doc """
  Same as get(), but it will unwrap the error tuple and raise in case of errors.
  """
  @spec get!(
    id: binary,
    user: Project.t() | Organization.t() | nil
  ) :: Log.t()
  def get!(id, options \\ []) do
    Rest.get_id!(resource(), id, options)
  end

  @doc """
  Receive a stream of PixRequest.Log structs previously created in the Stark Infra API

  ## Options:
    - `:limit` [integer, default nil]: maximum number of structs to be retrieved. Unlimited if nil. ex: 35
    - `:after` [Date or string, default nil]: date filter for structs created after a specified date. ex: ~D[2020, 3, 10]
    - `:before` [Date or string, default nil]: date filter for structs created before a specified date. ex: ~D[2020, 3, 10]
    - `:types` [list of strings, default nil]: filter retrieved structs by types. Options: "sent", "denied", "failed", "created", "success", "approved", "credited", "refunded", "processing".
    - `:request_ids` [list of strings, default nil]: list of PixRequest ids to filter retrieved objects. ex: ["5656565656565656", "4545454545454545"]
    - `:reconciliation_id` [string]: PixRequest reconciliation id to filter retrieved objects. ex: "b77f5236-7ab9-4487-9f95-66ee6eaf1781"
    - `:user` [Organization/Project, default nil]: Organization or Project struct returned from StarkInfra.project(). Only necessary if default project or organization has not been set in configs.

  ## Return:
    - stream of PixRequest.Log structs with updated attributes
  """
  @spec query(
    limit: integer,
    after: Date.t() | binary,
    before: Date.t() | binary,
    types: [binary],
    request_ids: [binary],
    reconciliation_id: binary,
    user: Project.t() | Organization.t() | nil
  ) ::
    {:ok, [Log.t()]} |
    {:error, [Error.t()]}
  def query(options \\ []) do
    Rest.get_list(resource(), options)
  end

  @doc """
  Same as query(), but it will unwrap the error tuple and raise in case of errors.
  """
  @spec query!(
    limit: integer,
    after: Date.t() | binary,
    before: Date.t() | binary,
    types: [binary],
    request_ids: [binary],
    reconciliation_id: binary,
    user: Project.t() | Organization.t() | nil
  ) :: [Log.t()]
  def query!(options \\ []) do
    Rest.get_list!(resource(), options)
  end

  @doc """
  Receive a list of up to 100 PixRequest.Log structs previously created in the Stark Infra API and the cursor to the next page.
  Use this function instead of query if you want to manually page your requests.

  ## Options:
    - `:cursor` [string, default nil]: cursor returned on the previous page function call
    - `:limit` [integer, default 100]: maximum number of structs to be retrieved. Max = 100. ex: 35
    - `:after` [Date or string, default nil]: date filter for structs created after a specified date. ex: ~D[2020, 3, 10]
    - `:before` [Date or string, default nil]: date filter for structs created before a specified date. ex: ~D[2020, 3, 10]
    - `:types` [list of strings, default nil]: filter retrieved structs by types. Options: “sent”, “denied”, “failed”, “created”, “success”, “approved”, “credited”, “refunded”, “processing”.
    - `:request_ids` [list of strings, default nil]: list of PixRequest IDs to filter retrieved objects. ex: ["5656565656565656", "4545454545454545"]
    - `:reconciliation_id` [string]: PixRequest reconciliation id to filter retrieved objects. ex: "b77f5236-7ab9-4487-9f95-66ee6eaf1781"
    - `:user` [Organization/Project, default nil]: Organization or Project struct returned from StarkInfra.project(). Only necessary if default project or organization has not been set in configs.

  ## Return:
    - list of PixRequest.Log structs with updated attributes
    - cursor to retrieve the next page of PixRequest.Log objects
  """
  @spec page(
    cursor: binary,
    limit: integer,
    after: Date.t() | binary,
    before: Date.t() | binary,
    types: [binary],
    request_ids: [binary],
    reconciliation_id: binary,
    user: Project.t() | Organization.t() | nil
  ) ::
    {:ok, [Log.t()], binary} |
    {:error, [Error.t()]}
  def page(options \\ []) do
    Rest.get_page(resource(), options)
  end

  @doc """
  Same as page(), but it will unwrap the error tuple and raise in case of errors.
  """
  @spec page!(
    cursor: binary,
    limit: integer,
    after: Date.t() | binary,
    before: Date.t() | binary,
    types: [binary],
    request_ids: [binary],
    reconciliation_id: binary,
    user: Project.t() | Organization.t() | nil
  ) :: [Log.t()]
  def page!(options \\ []) do
    Rest.get_page!(resource(), options)
  end

  @doc false
  def resource() do
    {
      "PixRequestLog",
      &resource_maker/1
    }
  end

  @doc false
  def resource_maker(json) do
    %Log{
      id: json[:id],
      created:  json[:created] |> Check.datetime(),
      type: json[:type],
      errors: json[:errors],
      request: json[:request] |> API.from_api_json(&PixRequest.resource_maker/1),
    }
  end
end
