extract_fit_engine <- function(model) {
  checkmate::assert_multi_class(model, c("lm", "model_fit", "workflow"))

  if (checkmate::test_multi_class(model, c("model_fit", "workflow"))) {
    model |> parsnip::extract_fit_engine()
  } else {
    model
  }
}
