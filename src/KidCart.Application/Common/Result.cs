namespace KidCart.Application.Common;

public class Result<T>
{
    public T? Value { get; }
    public bool IsSuccess { get; }
    public string? Error { get; }
    public List<string> Errors { get; } = new();

    private Result(T value) { Value = value; IsSuccess = true; }
    private Result(string error) { Error = error; IsSuccess = false; Errors.Add(error); }
    private Result(List<string> errors) { Error = errors.FirstOrDefault(); IsSuccess = false; Errors = errors; }

    public static Result<T> Success(T value) => new(value);
    public static Result<T> Failure(string error) => new(error);
    public static Result<T> Failure(List<string> errors) => new(errors);

    public static implicit operator Result<T>(T value) => Success(value);
}

public class Result
{
    public bool IsSuccess { get; }
    public string? Error { get; }

    private Result(bool success, string? error = null) { IsSuccess = success; Error = error; }

    public static Result Success() => new(true);
    public static Result Failure(string error) => new(false, error);
}
