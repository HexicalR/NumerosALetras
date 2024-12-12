namespace NumerosALetras.Request
{
    public class LogEventRequest
    {
        public bool ExecutionResult { get; set; }
        public Guid UserId { get; set; }
        public string Description { get; set; }
    }
}