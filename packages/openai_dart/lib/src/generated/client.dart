// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: invalid_annotation_target, unused_import

import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:meta/meta.dart';

import 'schema/schema.dart';

/// Enum of HTTP methods
enum HttpMethod { get, put, post, delete, options, head, patch, trace }

// ==========================================
// CLASS: OpenAIClientException
// ==========================================

/// HTTP exception handler for OpenAIClient
class OpenAIClientException implements Exception {
  OpenAIClientException({
    required this.message,
    required this.uri,
    required this.method,
    this.code,
    this.body,
  });

  final String message;
  final Uri uri;
  final HttpMethod method;
  final int? code;
  final Object? body;

  @override
  String toString() {
    Object? data;
    try {
      data = body is String ? jsonDecode(body as String) : body.toString();
    } catch (e) {
      data = body.toString();
    }
    final s = JsonEncoder.withIndent('  ').convert({
      'uri': uri.toString(),
      'method': method.name.toUpperCase(),
      'code': code,
      'message': message,
      'body': data,
    });
    return 'OpenAIClientException($s)';
  }
}

// ==========================================
// CLASS: OpenAIClient
// ==========================================

/// Client for OpenAI API (v.2.3.0)
///
/// The OpenAI REST API. Please see https://platform.openai.com/docs/api-reference for more details.
class OpenAIClient {
  /// Creates a new OpenAIClient instance.
  ///
  /// - [OpenAIClient.baseUrl] Override base URL (default: server url defined in spec)
  /// - [OpenAIClient.headers] Global headers to be sent with every request
  /// - [OpenAIClient.queryParams] Global query parameters to be sent with every request
  /// - [OpenAIClient.client] Override HTTP client to use for requests
  OpenAIClient({
    this.bearerToken = '',
    this.baseUrl,
    this.headers = const {},
    this.queryParams = const {},
    http.Client? client,
  })  : assert(
          baseUrl == null || baseUrl.startsWith('http'),
          'baseUrl must start with http',
        ),
        assert(
          baseUrl == null || !baseUrl.endsWith('/'),
          'baseUrl must not end with /',
        ),
        client = RetryClient(client ?? http.Client());

  /// Override base URL (default: server url defined in spec)
  final String? baseUrl;

  /// Global headers to be sent with every request
  final Map<String, String> headers;

  /// Global query parameters to be sent with every request
  final Map<String, dynamic> queryParams;

  /// HTTP client for requests
  final http.Client client;

  /// Authentication related variables
  String bearerToken;

  // ------------------------------------------
  // METHOD: endSession
  // ------------------------------------------

  /// Close the HTTP client and end session
  void endSession() => client.close();

  // ------------------------------------------
  // METHOD: onRequest
  // ------------------------------------------

  /// Middleware for HTTP requests (user can override)
  ///
  /// The request can be of type [http.Request] or [http.MultipartRequest]
  Future<http.BaseRequest> onRequest(http.BaseRequest request) {
    return Future.value(request);
  }

  // ------------------------------------------
  // METHOD: onStreamedResponse
  // ------------------------------------------

  /// Middleware for HTTP streamed responses (user can override)
  Future<http.StreamedResponse> onStreamedResponse(
    final http.StreamedResponse response,
  ) {
    return Future.value(response);
  }

  // ------------------------------------------
  // METHOD: onResponse
  // ------------------------------------------

  /// Middleware for HTTP responses (user can override)
  Future<http.Response> onResponse(http.Response response) {
    return Future.value(response);
  }

  // ------------------------------------------
  // METHOD: _jsonDecode
  // ------------------------------------------

  dynamic _jsonDecode(http.Response r) {
    return json.decode(utf8.decode(r.bodyBytes));
  }

  // ------------------------------------------
  // METHOD: _request
  // ------------------------------------------

  /// Reusable request method
  @protected
  Future<http.StreamedResponse> _request({
    required String baseUrl,
    required String path,
    required HttpMethod method,
    Map<String, dynamic> queryParams = const {},
    Map<String, String> headerParams = const {},
    bool isMultipart = false,
    String requestType = '',
    String responseType = '',
    Object? body,
  }) async {
    // Override with the user provided baseUrl
    baseUrl = this.baseUrl ?? baseUrl;

    // Ensure a baseUrl is provided
    assert(
      baseUrl.isNotEmpty,
      'baseUrl is required, but none defined in spec or provided by user',
    );

    // Add global query parameters
    queryParams = {...queryParams, ...this.queryParams};

    // Ensure query parameters are strings or iterable of strings
    queryParams = queryParams.map((key, value) {
      if (value is Iterable) {
        return MapEntry(key, value.map((v) => v.toString()));
      } else {
        return MapEntry(key, value.toString());
      }
    });

    // Build the request URI
    Uri uri = Uri.parse(baseUrl + path);
    if (queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: queryParams);
    }

    // Build the headers
    Map<String, String> headers = {...headerParams};

    // Add bearer token to request headers
    if (bearerToken.isNotEmpty) {
      headers['authorization'] = 'Bearer $bearerToken';
    }

    // Define the request type being sent to server
    if (requestType.isNotEmpty) {
      headers['content-type'] = requestType;
    }

    // Define the response type expected to receive from server
    if (responseType.isNotEmpty) {
      headers['accept'] = responseType;
    }

    // Add global headers
    headers.addAll(this.headers);

    // Build the request object
    http.BaseRequest request;
    if (isMultipart) {
      // Handle multipart request
      request = http.MultipartRequest(method.name, uri);
      request = request as http.MultipartRequest;
      if (body is List<http.MultipartFile>) {
        request.files.addAll(body);
      } else {
        request.files.add(body as http.MultipartFile);
      }
    } else {
      // Handle normal request
      request = http.Request(method.name, uri);
      request = request as http.Request;
      try {
        if (body != null) {
          request.body = json.encode(body);
        }
      } catch (e) {
        // Handle request encoding error
        throw OpenAIClientException(
          uri: uri,
          method: method,
          message: 'Could not encode: ${body.runtimeType}',
          body: e,
        );
      }
    }

    // Add request headers
    request.headers.addAll(headers);

    // Handle user request middleware
    request = await onRequest(request);

    // Submit request
    return await client.send(request);
  }

  // ------------------------------------------
  // METHOD: makeRequestStream
  // ------------------------------------------

  /// Reusable request stream method
  @protected
  Future<http.StreamedResponse> makeRequestStream({
    required String baseUrl,
    required String path,
    required HttpMethod method,
    Map<String, dynamic> queryParams = const {},
    Map<String, String> headerParams = const {},
    bool isMultipart = false,
    String requestType = '',
    String responseType = '',
    Object? body,
  }) async {
    final uri = Uri.parse((this.baseUrl ?? baseUrl) + path);
    late http.StreamedResponse response;
    try {
      response = await _request(
        baseUrl: baseUrl,
        path: path,
        method: method,
        queryParams: queryParams,
        headerParams: headerParams,
        requestType: requestType,
        responseType: responseType,
        body: body,
      );
      // Handle user response middleware
      response = await onStreamedResponse(response);
    } catch (e) {
      // Handle request and response errors
      throw OpenAIClientException(
        uri: uri,
        method: method,
        message: 'Response error',
        body: e,
      );
    }

    // Check for successful response
    if ((response.statusCode ~/ 100) == 2) {
      return response;
    }

    // Handle unsuccessful response
    throw OpenAIClientException(
      uri: uri,
      method: method,
      message: 'Unsuccessful response',
      code: response.statusCode,
      body: (await http.Response.fromStream(response)).body,
    );
  }

  // ------------------------------------------
  // METHOD: makeRequest
  // ------------------------------------------

  /// Reusable request method
  @protected
  Future<http.Response> makeRequest({
    required String baseUrl,
    required String path,
    required HttpMethod method,
    Map<String, dynamic> queryParams = const {},
    Map<String, String> headerParams = const {},
    bool isMultipart = false,
    String requestType = '',
    String responseType = '',
    Object? body,
  }) async {
    final uri = Uri.parse((this.baseUrl ?? baseUrl) + path);
    late http.Response response;
    try {
      final streamedResponse = await _request(
        baseUrl: baseUrl,
        path: path,
        method: method,
        queryParams: queryParams,
        headerParams: headerParams,
        requestType: requestType,
        responseType: responseType,
        body: body,
      );
      response = await http.Response.fromStream(streamedResponse);
      // Handle user response middleware
      response = await onResponse(response);
    } catch (e) {
      // Handle request and response errors
      throw OpenAIClientException(
        uri: uri,
        method: method,
        message: 'Response error',
        body: e,
      );
    }

    // Check for successful response
    if ((response.statusCode ~/ 100) == 2) {
      return response;
    }

    // Handle unsuccessful response
    throw OpenAIClientException(
      uri: uri,
      method: method,
      message: 'Unsuccessful response',
      code: response.statusCode,
      body: response.body,
    );
  }

  // ------------------------------------------
  // METHOD: createChatCompletion
  // ------------------------------------------

  /// Create chat completion
  ///
  /// Creates a model response for the given chat conversation. Learn more in the
  /// [text generation](https://platform.openai.com/docs/guides/text-generation),
  /// [vision](https://platform.openai.com/docs/guides/vision), and
  /// [audio](https://platform.openai.com/docs/guides/audio) guides.
  ///
  /// Parameter support can differ depending on the model used to generate the
  /// response, particularly for newer reasoning models. Parameters that are only
  /// supported for reasoning models are noted below. For the current state of
  /// unsupported parameters in reasoning models,
  /// [refer to the reasoning guide](https://platform.openai.com/docs/guides/reasoning).
  ///
  /// `request`: Request object for the Create chat completion endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/chat/completions`
  Future<CreateChatCompletionResponse> createChatCompletion({
    required CreateChatCompletionRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/chat/completions',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return CreateChatCompletionResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createCompletion
  // ------------------------------------------

  /// Create completion
  ///
  /// Creates a completion for the provided prompt and parameters.
  ///
  /// `request`: Request object for the Create completion endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/completions`
  Future<CreateCompletionResponse> createCompletion({
    required CreateCompletionRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/completions',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return CreateCompletionResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createEmbedding
  // ------------------------------------------

  /// Create embeddings
  ///
  /// Creates an embedding vector representing the input text.
  ///
  /// `request`: Request object for the Create embedding endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/embeddings`
  Future<CreateEmbeddingResponse> createEmbedding({
    required CreateEmbeddingRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/embeddings',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return CreateEmbeddingResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listPaginatedFineTuningJobs
  // ------------------------------------------

  /// List fine-tuning jobs
  ///
  /// List your organization's fine-tuning jobs.
  ///
  /// `after`: Identifier for the last job from the previous pagination request.
  ///
  /// `limit`: Number of fine-tuning jobs to retrieve.
  ///
  /// `GET` `https://api.openai.com/v1/fine_tuning/jobs`
  Future<ListPaginatedFineTuningJobsResponse> listPaginatedFineTuningJobs({
    String? after,
    int limit = 20,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/fine_tuning/jobs',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        if (after != null) 'after': after,
        'limit': limit,
      },
    );
    return ListPaginatedFineTuningJobsResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createFineTuningJob
  // ------------------------------------------

  /// Create fine-tuning job
  ///
  /// Creates a fine-tuning job which begins the process of creating a new model from a given dataset.
  ///
  /// Response includes details of the enqueued job including job status and the name of the fine-tuned models
  /// once complete.
  ///
  /// [Learn more about fine-tuning](https://platform.openai.com/docs/guides/fine-tuning).
  ///
  /// `request`: Request object for the Create fine-tuning job endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/fine_tuning/jobs`
  Future<FineTuningJob> createFineTuningJob({
    required CreateFineTuningJobRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/fine_tuning/jobs',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return FineTuningJob.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: retrieveFineTuningJob
  // ------------------------------------------

  /// Retrieve fine-tuning job
  ///
  /// Get info about a fine-tuning job.
  ///
  /// [Learn more about fine-tuning](https://platform.openai.com/docs/guides/fine-tuning).
  ///
  /// `fineTuningJobId`: The ID of the fine-tuning job.
  ///
  /// `GET` `https://api.openai.com/v1/fine_tuning/jobs/{fine_tuning_job_id}`
  Future<FineTuningJob> retrieveFineTuningJob({
    required String fineTuningJobId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/fine_tuning/jobs/$fineTuningJobId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return FineTuningJob.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listFineTuningEvents
  // ------------------------------------------

  /// List fine-tuning events
  ///
  /// Get status updates for a fine-tuning job.
  ///
  /// `fineTuningJobId`: The ID of the fine-tuning job to get events for.
  ///
  /// `after`: Identifier for the last event from the previous pagination request.
  ///
  /// `limit`: Number of events to retrieve.
  ///
  /// `GET` `https://api.openai.com/v1/fine_tuning/jobs/{fine_tuning_job_id}/events`
  Future<ListFineTuningJobEventsResponse> listFineTuningEvents({
    required String fineTuningJobId,
    String? after,
    int limit = 20,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/fine_tuning/jobs/$fineTuningJobId/events',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        if (after != null) 'after': after,
        'limit': limit,
      },
    );
    return ListFineTuningJobEventsResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: cancelFineTuningJob
  // ------------------------------------------

  /// Cancel fine-tuning
  ///
  /// Immediately cancel a fine-tune job.
  ///
  /// `fineTuningJobId`: The ID of the fine-tuning job to cancel.
  ///
  /// `POST` `https://api.openai.com/v1/fine_tuning/jobs/{fine_tuning_job_id}/cancel`
  Future<FineTuningJob> cancelFineTuningJob({
    required String fineTuningJobId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/fine_tuning/jobs/$fineTuningJobId/cancel',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return FineTuningJob.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listFineTuningJobCheckpoints
  // ------------------------------------------

  /// List fine-tuning checkpoints
  ///
  /// List checkpoints for a fine-tuning job.
  ///
  /// `fineTuningJobId`: The ID of the fine-tuning job to get checkpoints for.
  ///
  /// `after`: Identifier for the last checkpoint ID from the previous pagination request.
  ///
  /// `limit`: Number of checkpoints to retrieve.
  ///
  /// `GET` `https://api.openai.com/v1/fine_tuning/jobs/{fine_tuning_job_id}/checkpoints`
  Future<ListFineTuningJobCheckpointsResponse> listFineTuningJobCheckpoints({
    required String fineTuningJobId,
    String? after,
    int limit = 10,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/fine_tuning/jobs/$fineTuningJobId/checkpoints',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        if (after != null) 'after': after,
        'limit': limit,
      },
    );
    return ListFineTuningJobCheckpointsResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createImage
  // ------------------------------------------

  /// Create image
  ///
  /// Creates an image given a prompt.
  ///
  /// `request`: Request object for the Create image endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/images/generations`
  Future<ImagesResponse> createImage({
    required CreateImageRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/images/generations',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return ImagesResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listModels
  // ------------------------------------------

  /// List models
  ///
  /// Lists the currently available models, and provides basic information about each one such as the owner
  /// and availability.
  ///
  /// `GET` `https://api.openai.com/v1/models`
  Future<ListModelsResponse> listModels() async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/models',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return ListModelsResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: retrieveModel
  // ------------------------------------------

  /// Retrieve model
  ///
  /// Retrieves a model instance, providing basic information about the model such as the owner
  /// and permissioning.
  ///
  /// `model`: The ID of the model to use for this request
  ///
  /// `GET` `https://api.openai.com/v1/models/{model}`
  Future<Model> retrieveModel({
    required String model,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/models/$model',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return Model.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: deleteModel
  // ------------------------------------------

  /// Delete a fine-tuned model
  ///
  /// Delete a fine-tuned model. You must have the Owner role in your organization to delete a model.
  ///
  /// `model`: The model to delete
  ///
  /// `DELETE` `https://api.openai.com/v1/models/{model}`
  Future<DeleteModelResponse> deleteModel({
    required String model,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/models/$model',
      method: HttpMethod.delete,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return DeleteModelResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createModeration
  // ------------------------------------------

  /// Create moderation
  ///
  /// Classifies if text and/or image inputs are potentially harmful. Learn
  /// more in the [moderation guide](https://platform.openai.com/docs/guides/moderation).
  ///
  /// `request`: Request object for the Create moderation endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/moderations`
  Future<CreateModerationResponse> createModeration({
    required CreateModerationRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/moderations',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return CreateModerationResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listAssistants
  // ------------------------------------------

  /// List assistants.
  ///
  /// Returns a list of assistants.
  ///
  /// `limit`: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ///
  /// `order`: Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ///
  /// `after`: A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ///
  /// `before`: A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ///
  /// `GET` `https://api.openai.com/v1/assistants`
  Future<ListAssistantsResponse> listAssistants({
    int limit = 20,
    String order = 'desc',
    String? after,
    String? before,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/assistants',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        'limit': limit,
        'order': order,
        if (after != null) 'after': after,
        if (before != null) 'before': before,
      },
    );
    return ListAssistantsResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createAssistant
  // ------------------------------------------

  /// Create assistant
  ///
  /// Create an assistant with a model and instructions.
  ///
  /// `request`: Request object for the Create assistant endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/assistants`
  Future<AssistantObject> createAssistant({
    required CreateAssistantRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/assistants',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return AssistantObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: getAssistant
  // ------------------------------------------

  /// Retrieve assistant
  ///
  /// Retrieves an assistant.
  ///
  /// `assistantId`: The ID of the assistant to retrieve.
  ///
  /// `GET` `https://api.openai.com/v1/assistants/{assistant_id}`
  Future<AssistantObject> getAssistant({
    required String assistantId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/assistants/$assistantId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return AssistantObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: modifyAssistant
  // ------------------------------------------

  /// Modify assistant
  ///
  /// Modifies an assistant.
  ///
  /// `assistantId`: The ID of the assistant to modify.
  ///
  /// `request`: Request object for the Modify assistant endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/assistants/{assistant_id}`
  Future<AssistantObject> modifyAssistant({
    required String assistantId,
    required ModifyAssistantRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/assistants/$assistantId',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return AssistantObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: deleteAssistant
  // ------------------------------------------

  /// Delete assistant
  ///
  /// Delete an assistant.
  ///
  /// `assistantId`: The ID of the assistant to delete.
  ///
  /// `DELETE` `https://api.openai.com/v1/assistants/{assistant_id}`
  Future<DeleteAssistantResponse> deleteAssistant({
    required String assistantId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/assistants/$assistantId',
      method: HttpMethod.delete,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return DeleteAssistantResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createThread
  // ------------------------------------------

  /// Create thread
  ///
  /// Create a thread.
  ///
  /// `request`: Request object for the Create thread endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/threads`
  Future<ThreadObject> createThread({
    CreateThreadRequest? request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return ThreadObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: getThread
  // ------------------------------------------

  /// Retrieves a thread.
  ///
  /// `threadId`: The ID of the thread to retrieve.
  ///
  /// `GET` `https://api.openai.com/v1/threads/{thread_id}`
  Future<ThreadObject> getThread({
    required String threadId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return ThreadObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: modifyThread
  // ------------------------------------------

  /// Modifies a thread.
  ///
  /// `threadId`: The ID of the thread to modify. Only the `metadata` can be modified.
  ///
  /// `request`: Request object for the Modify thread endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/threads/{thread_id}`
  Future<ThreadObject> modifyThread({
    required String threadId,
    required ModifyThreadRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return ThreadObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: deleteThread
  // ------------------------------------------

  /// Delete thread
  ///
  /// Delete a thread.
  ///
  /// `threadId`: The ID of the thread to delete.
  ///
  /// `DELETE` `https://api.openai.com/v1/threads/{thread_id}`
  Future<DeleteThreadResponse> deleteThread({
    required String threadId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId',
      method: HttpMethod.delete,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return DeleteThreadResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listThreadMessages
  // ------------------------------------------

  /// List thread messages
  ///
  /// Returns a list of messages for a given thread.
  ///
  /// `threadId`: The ID of the [thread](https://platform.openai.com/docs/api-reference/threads) the messages belong to.
  ///
  /// `limit`: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ///
  /// `order`: Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ///
  /// `after`: A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ///
  /// `before`: A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ///
  /// `runId`: Filter messages by the run ID that generated them.
  ///
  /// `GET` `https://api.openai.com/v1/threads/{thread_id}/messages`
  Future<ListMessagesResponse> listThreadMessages({
    required String threadId,
    int limit = 20,
    String order = 'desc',
    String? after,
    String? before,
    String? runId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/messages',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        'limit': limit,
        'order': order,
        if (after != null) 'after': after,
        if (before != null) 'before': before,
        if (runId != null) 'run_id': runId,
      },
    );
    return ListMessagesResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createThreadMessage
  // ------------------------------------------

  /// Create message
  ///
  /// Create a message.
  ///
  /// `threadId`: The ID of the [thread](https://platform.openai.com/docs/api-reference/threads) to create a message for.
  ///
  /// `request`: Request object for the Create message endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/threads/{thread_id}/messages`
  Future<MessageObject> createThreadMessage({
    required String threadId,
    required CreateMessageRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/messages',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return MessageObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: getThreadMessage
  // ------------------------------------------

  /// Retrieve message
  ///
  /// Retrieve a message.
  ///
  /// `threadId`: The ID of the [thread](https://platform.openai.com/docs/api-reference/threads) to which this message belongs.
  ///
  /// `messageId`: The ID of the message to retrieve.
  ///
  /// `GET` `https://api.openai.com/v1/threads/{thread_id}/messages/{message_id}`
  Future<MessageObject> getThreadMessage({
    required String threadId,
    required String messageId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/messages/$messageId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return MessageObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: modifyThreadMessage
  // ------------------------------------------

  /// Modify message
  ///
  /// Modifies a message.
  ///
  /// `threadId`: The ID of the thread to which this message belongs.
  ///
  /// `messageId`: The ID of the message to modify.
  ///
  /// `request`: Request object for the Modify message endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/threads/{thread_id}/messages/{message_id}`
  Future<MessageObject> modifyThreadMessage({
    required String threadId,
    required String messageId,
    required ModifyMessageRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/messages/$messageId',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return MessageObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: deleteThreadMessage
  // ------------------------------------------

  /// Delete message
  ///
  /// Deletes a message.
  ///
  /// `threadId`: The ID of the thread to which this message belongs.
  ///
  /// `messageId`: The ID of the message to delete.
  ///
  /// `DELETE` `https://api.openai.com/v1/threads/{thread_id}/messages/{message_id}`
  Future<DeleteMessageResponse> deleteThreadMessage({
    required String threadId,
    required String messageId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/messages/$messageId',
      method: HttpMethod.delete,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return DeleteMessageResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createThreadAndRun
  // ------------------------------------------

  /// Create thread and run
  ///
  /// Create a thread and run it in one request.
  ///
  /// `request`: Request object for the Create thread and run endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/threads/runs`
  Future<RunObject> createThreadAndRun({
    required CreateThreadAndRunRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/runs',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return RunObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listThreadRuns
  // ------------------------------------------

  /// List runs
  ///
  /// Returns a list of runs belonging to a thread.
  ///
  /// `threadId`: The ID of the thread the run belongs to.
  ///
  /// `limit`: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ///
  /// `order`: Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ///
  /// `after`: A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ///
  /// `before`: A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ///
  /// `GET` `https://api.openai.com/v1/threads/{thread_id}/runs`
  Future<ListRunsResponse> listThreadRuns({
    required String threadId,
    int limit = 20,
    String order = 'desc',
    String? after,
    String? before,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/runs',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        'limit': limit,
        'order': order,
        if (after != null) 'after': after,
        if (before != null) 'before': before,
      },
    );
    return ListRunsResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createThreadRun
  // ------------------------------------------

  /// Create run
  ///
  /// Create a run.
  ///
  /// `threadId`: The ID of the thread to run.
  ///
  /// `include`: A list of additional fields to include in the response. Currently the only supported value is  `step_details.tool_calls[*].file_search.results[*].content` to fetch the file search result content.  See the [file search tool documentation](https://platform.openai.com/docs/assistants/tools/file-search#customizing-file-search-settings)  for more information.
  ///
  /// `request`: Request object for the Create run endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/threads/{thread_id}/runs`
  Future<RunObject> createThreadRun({
    required String threadId,
    String? include,
    required CreateRunRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/runs',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
      queryParams: {
        if (include != null) 'include': include,
      },
    );
    return RunObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: getThreadRun
  // ------------------------------------------

  /// Retrieve run
  ///
  /// Retrieves a run.
  ///
  /// `threadId`: The ID of the [thread](https://platform.openai.com/docs/api-reference/threads) that was run.
  ///
  /// `runId`: The ID of the run to retrieve.
  ///
  /// `GET` `https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}`
  Future<RunObject> getThreadRun({
    required String threadId,
    required String runId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/runs/$runId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return RunObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: modifyThreadRun
  // ------------------------------------------

  /// Modify run
  ///
  /// Modifies a run.
  ///
  /// `threadId`: The ID of the [thread](https://platform.openai.com/docs/api-reference/threads) that was run.
  ///
  /// `runId`: The ID of the run to modify.
  ///
  /// `request`: Request object for the Modify run endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}`
  Future<RunObject> modifyThreadRun({
    required String threadId,
    required String runId,
    required ModifyRunRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/runs/$runId',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return RunObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: submitThreadToolOutputsToRun
  // ------------------------------------------

  /// Submit tool outputs to run
  ///
  /// When a run has the `status: "requires_action"` and `required_action.type` is `submit_tool_outputs`,
  /// this endpoint can be used to submit the outputs from the tool calls once they're all completed.
  /// All outputs must be submitted in a single request.
  ///
  /// `threadId`: The ID of the [thread](https://platform.openai.com/docs/api-reference/threads) to which this run belongs.
  ///
  /// `runId`: The ID of the run that requires the tool output submission.
  ///
  /// `request`: Request object for the Submit tool outputs to run endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}/submit_tool_outputs`
  Future<RunObject> submitThreadToolOutputsToRun({
    required String threadId,
    required String runId,
    required SubmitToolOutputsRunRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/runs/$runId/submit_tool_outputs',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return RunObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: cancelThreadRun
  // ------------------------------------------

  /// Cancel a run
  ///
  /// Cancels a run that is `in_progress`.
  ///
  /// `threadId`: The ID of the thread to which this run belongs.
  ///
  /// `runId`: The ID of the run to cancel.
  ///
  /// `POST` `https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}/cancel`
  Future<RunObject> cancelThreadRun({
    required String threadId,
    required String runId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/runs/$runId/cancel',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return RunObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listThreadRunSteps
  // ------------------------------------------

  /// List run steps
  ///
  /// Returns a list of run steps belonging to a run.
  ///
  /// `threadId`: The ID of the thread the run and run steps belong to.
  ///
  /// `runId`: The ID of the run the run steps belong to.
  ///
  /// `limit`: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ///
  /// `order`: Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ///
  /// `after`: A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ///
  /// `before`: A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ///
  /// `include`: A list of additional fields to include in the response. Currently the only supported value is  `step_details.tool_calls[*].file_search.results[*].content` to fetch the file search result content.  See the [file search tool documentation](https://platform.openai.com/docs/assistants/tools/file-search#customizing-file-search-settings)  for more information.
  ///
  /// `GET` `https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}/steps`
  Future<ListRunStepsResponse> listThreadRunSteps({
    required String threadId,
    required String runId,
    int limit = 20,
    String order = 'desc',
    String? after,
    String? before,
    String? include,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/runs/$runId/steps',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        'limit': limit,
        'order': order,
        if (after != null) 'after': after,
        if (before != null) 'before': before,
        if (include != null) 'include': include,
      },
    );
    return ListRunStepsResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: getThreadRunStep
  // ------------------------------------------

  /// Retrieve run step
  ///
  /// Retrieves a run step.
  ///
  /// `threadId`: The ID of the thread to which the run and run step belongs.
  ///
  /// `runId`: The ID of the run to which the run step belongs.
  ///
  /// `stepId`: The ID of the run step to retrieve.
  ///
  /// `include`: A list of additional fields to include in the response. Currently the only supported value is  `step_details.tool_calls[*].file_search.results[*].content` to fetch the file search result content.  See the [file search tool documentation](https://platform.openai.com/docs/assistants/tools/file-search#customizing-file-search-settings)  for more information.
  ///
  /// `GET` `https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}/steps/{step_id}`
  Future<RunStepObject> getThreadRunStep({
    required String threadId,
    required String runId,
    required String stepId,
    String? include,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/threads/$threadId/runs/$runId/steps/$stepId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        if (include != null) 'include': include,
      },
    );
    return RunStepObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listVectorStores
  // ------------------------------------------

  /// List vector stores
  ///
  /// Returns a list of vector stores.
  ///
  /// `limit`: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ///
  /// `order`: Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ///
  /// `after`: A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ///
  /// `before`: A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ///
  /// `GET` `https://api.openai.com/v1/vector_stores`
  Future<ListVectorStoresResponse> listVectorStores({
    int limit = 20,
    String order = 'desc',
    String? after,
    String? before,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        'limit': limit,
        'order': order,
        if (after != null) 'after': after,
        if (before != null) 'before': before,
      },
    );
    return ListVectorStoresResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createVectorStore
  // ------------------------------------------

  /// Create vector store
  ///
  /// Create a vector store.
  ///
  /// `request`: Request object for the Create assistant file endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/vector_stores`
  Future<VectorStoreObject> createVectorStore({
    required CreateVectorStoreRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return VectorStoreObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: getVectorStore
  // ------------------------------------------

  /// Retrieve vector store
  ///
  /// Retrieves a vector store.
  ///
  /// `vectorStoreId`: The ID of the vector store to retrieve.
  ///
  /// `GET` `https://api.openai.com/v1/vector_stores/{vector_store_id}`
  Future<VectorStoreObject> getVectorStore({
    required String vectorStoreId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return VectorStoreObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: modifyVectorStore
  // ------------------------------------------

  /// Modifies a vector store.
  ///
  /// Modifies a vector store.
  ///
  /// `vectorStoreId`: The ID of the vector store to modify.
  ///
  /// `request`: Request object for the Update vector store endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/vector_stores/{vector_store_id}`
  Future<VectorStoreObject> modifyVectorStore({
    required String vectorStoreId,
    required UpdateVectorStoreRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return VectorStoreObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: deleteVectorStore
  // ------------------------------------------

  /// Delete vector store
  ///
  /// Delete a vector store.
  ///
  /// `vectorStoreId`: The ID of the vector store to delete.
  ///
  /// `DELETE` `https://api.openai.com/v1/vector_stores/{vector_store_id}`
  Future<DeleteVectorStoreResponse> deleteVectorStore({
    required String vectorStoreId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId',
      method: HttpMethod.delete,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return DeleteVectorStoreResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listVectorStoreFiles
  // ------------------------------------------

  /// List vector store files
  ///
  /// Returns a list of vector store files.
  ///
  /// `vectorStoreId`: The ID of the vector store that the files belong to.
  ///
  /// `limit`: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ///
  /// `order`: Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ///
  /// `after`: A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ///
  /// `before`: A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ///
  /// `filter`: Filter by file status. One of `in_progress`, `completed`, `failed`, `cancelled`.
  ///
  /// `GET` `https://api.openai.com/v1/vector_stores/{vector_store_id}/files`
  Future<ListVectorStoreFilesResponse> listVectorStoreFiles({
    required String vectorStoreId,
    int limit = 20,
    String order = 'desc',
    String? after,
    String? before,
    String? filter,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId/files',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        'limit': limit,
        'order': order,
        if (after != null) 'after': after,
        if (before != null) 'before': before,
        if (filter != null) 'filter': filter,
      },
    );
    return ListVectorStoreFilesResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createVectorStoreFile
  // ------------------------------------------

  /// Create vector store file
  ///
  /// Create a vector store file by attaching a [File](https://platform.openai.com/docs/api-reference/files)
  /// to a [vector store](https://platform.openai.com/docs/api-reference/vector-stores/object).
  ///
  /// `vectorStoreId`: The ID of the vector store for which to create a File.
  ///
  /// `request`: Request object for the Create vector store file endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/vector_stores/{vector_store_id}/files`
  Future<VectorStoreFileObject> createVectorStoreFile({
    required String vectorStoreId,
    required CreateVectorStoreFileRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId/files',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return VectorStoreFileObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: getVectorStoreFile
  // ------------------------------------------

  /// Retrieve vector store file
  ///
  /// Retrieves a vector store file.
  ///
  /// `vectorStoreId`: The ID of the vector store that the file belongs to.
  ///
  /// `fileId`: The ID of the file being retrieved.
  ///
  /// `GET` `https://api.openai.com/v1/vector_stores/{vector_store_id}/files/{file_id}`
  Future<VectorStoreFileObject> getVectorStoreFile({
    required String vectorStoreId,
    required String fileId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId/files/$fileId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return VectorStoreFileObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: deleteVectorStoreFile
  // ------------------------------------------

  /// Delete vector store file
  ///
  /// Delete a vector store file. This will remove the file from the vector store but the file itself will
  /// not be deleted. To delete the file, use the [delete file](https://platform.openai.com/docs/api-reference/files/delete)
  /// endpoint.
  ///
  /// `vectorStoreId`: The ID of the vector store that the file belongs to.
  ///
  /// `fileId`: The ID of the file to delete.
  ///
  /// `DELETE` `https://api.openai.com/v1/vector_stores/{vector_store_id}/files/{file_id}`
  Future<DeleteVectorStoreFileResponse> deleteVectorStoreFile({
    required String vectorStoreId,
    required String fileId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId/files/$fileId',
      method: HttpMethod.delete,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return DeleteVectorStoreFileResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createVectorStoreFileBatch
  // ------------------------------------------

  /// Create vector store file batch
  ///
  /// Create a vector store file batch.
  ///
  /// `vectorStoreId`: The ID of the vector store for which to create a File Batch.
  ///
  /// `request`: Request object for the Create vector store file batch endpoint.
  ///
  /// `POST` `https://api.openai.com/v1/vector_stores/{vector_store_id}/file_batches`
  Future<VectorStoreFileBatchObject> createVectorStoreFileBatch({
    required String vectorStoreId,
    required CreateVectorStoreFileBatchRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId/file_batches',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return VectorStoreFileBatchObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: getVectorStoreFileBatch
  // ------------------------------------------

  /// Retrieve vector store file batch
  ///
  /// Retrieves a vector store file batch.
  ///
  /// `vectorStoreId`: The ID of the vector store that the file batch belongs to.
  ///
  /// `batchId`: The ID of the file batch being retrieved.
  ///
  /// `GET` `https://api.openai.com/v1/vector_stores/{vector_store_id}/file_batches/{batch_id}`
  Future<VectorStoreFileBatchObject> getVectorStoreFileBatch({
    required String vectorStoreId,
    required String batchId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId/file_batches/$batchId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return VectorStoreFileBatchObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: cancelVectorStoreFileBatch
  // ------------------------------------------

  /// Cancel vector store file batch
  ///
  /// Cancel a vector store file batch. This attempts to cancel the processing of files in this batch
  /// as soon as possible.
  ///
  /// `vectorStoreId`: The ID of the vector store that the file batch belongs to.
  ///
  /// `batchId`: The ID of the file batch to cancel.
  ///
  /// `POST` `https://api.openai.com/v1/vector_stores/{vector_store_id}/file_batches/{batch_id}/cancel`
  Future<VectorStoreFileBatchObject> cancelVectorStoreFileBatch({
    required String vectorStoreId,
    required String batchId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId/file_batches/$batchId/cancel',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return VectorStoreFileBatchObject.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listFilesInVectorStoreBatch
  // ------------------------------------------

  /// List vector store files in a batch
  ///
  /// Returns a list of vector store files in a batch.
  ///
  /// `vectorStoreId`: The ID of the vector store that the files belong to.
  ///
  /// `batchId`: The ID of the file batch that the files belong to.
  ///
  /// `limit`: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ///
  /// `order`: Sort order by the `created_at` timestamp of the objects. `asc` for ascending order and `desc` for descending order.
  ///
  /// `after`: A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ///
  /// `before`: A cursor for use in pagination. `before` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, starting with obj_foo, your subsequent call can include before=obj_foo in order to fetch the previous page of the list.
  ///
  /// `filter`: Filter by file status. One of `in_progress`, `completed`, `failed`, `cancelled`.
  ///
  /// `GET` `https://api.openai.com/v1/vector_stores/{vector_store_id}/file_batches/{batch_id}/files`
  Future<ListVectorStoreFilesResponse> listFilesInVectorStoreBatch({
    required String vectorStoreId,
    required String batchId,
    int limit = 20,
    String order = 'desc',
    String? after,
    String? before,
    String? filter,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/vector_stores/$vectorStoreId/file_batches/$batchId/files',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        'limit': limit,
        'order': order,
        if (after != null) 'after': after,
        if (before != null) 'before': before,
        if (filter != null) 'filter': filter,
      },
    );
    return ListVectorStoreFilesResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: listBatches
  // ------------------------------------------

  /// List batch
  ///
  /// List your organization's batches.
  ///
  /// `after`: A cursor for use in pagination. `after` is an object ID that defines your place in the list. For instance, if you make a list request and receive 100 objects, ending with obj_foo, your subsequent call can include after=obj_foo in order to fetch the next page of the list.
  ///
  /// `limit`: A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 20.
  ///
  /// `GET` `https://api.openai.com/v1/batches`
  Future<ListBatchesResponse> listBatches({
    String? after,
    int limit = 20,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/batches',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
      queryParams: {
        if (after != null) 'after': after,
        'limit': limit,
      },
    );
    return ListBatchesResponse.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: createBatch
  // ------------------------------------------

  /// Create batch
  ///
  /// Creates and executes a batch from an uploaded file of requests
  ///
  /// `request`: Represents a request to create a new batch.
  ///
  /// `POST` `https://api.openai.com/v1/batches`
  Future<Batch> createBatch({
    required CreateBatchRequest request,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/batches',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: 'application/json',
      responseType: 'application/json',
      body: request,
    );
    return Batch.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: retrieveBatch
  // ------------------------------------------

  /// Retrieve batch
  ///
  /// Retrieves a batch.
  ///
  /// `batchId`: The ID of the batch to retrieve.
  ///
  /// `GET` `https://api.openai.com/v1/batches/{batch_id}`
  Future<Batch> retrieveBatch({
    required String batchId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/batches/$batchId',
      method: HttpMethod.get,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return Batch.fromJson(_jsonDecode(r));
  }

  // ------------------------------------------
  // METHOD: cancelBatch
  // ------------------------------------------

  /// Cancel batch
  ///
  /// Cancels an in-progress batch. The batch will be in status `cancelling` for up to 10 minutes, before changing
  /// to `cancelled`, where it will have partial results (if any) available in the output file.
  ///
  /// `batchId`: The ID of the batch to cancel.
  ///
  /// `POST` `https://api.openai.com/v1/batches/{batch_id}/cancel`
  Future<Batch> cancelBatch({
    required String batchId,
  }) async {
    final r = await makeRequest(
      baseUrl: 'https://api.openai.com/v1',
      path: '/batches/$batchId/cancel',
      method: HttpMethod.post,
      isMultipart: false,
      requestType: '',
      responseType: 'application/json',
    );
    return Batch.fromJson(_jsonDecode(r));
  }
}
