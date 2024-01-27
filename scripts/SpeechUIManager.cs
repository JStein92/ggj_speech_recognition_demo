using Godot;
using System;
using System.Text.Json;

public partial class SpeechUIManager : Node
{
	[Export] Button startButton;
	[Export] Label partialResultText;
	[Export] Label finalResultText;
	[Export] SpeechRecognizer speechRecognizer;
	[Export] public NodePath PhraseManagerPath;
	private Node phraseManager;
	
	private string partialResult;
	private string finalResult;
	
	public override void _Ready()
	{
		SetProcessInput(true); // Make sure the node processes input events
		if (PhraseManagerPath != null)
		{
			phraseManager = GetNode(PhraseManagerPath);
		}
		startButton.Pressed += () =>
		{
			if (!speechRecognizer.isCurrentlyListening())
			{
				partialResultText.Text = "";
				finalResultText.Text = "";
				OnStartSpeechRecognition();
				speechRecognizer.StartSpeechRecognition();
			}
			else
			{
				OnStopSpeechRecognition();
				finalResult = speechRecognizer.StopSpeechRecoginition();
			}
		};
		speechRecognizer.OnPartialResult += (partialResult) =>
		{
			try
			{
				using JsonDocument doc = JsonDocument.Parse(partialResult);
				JsonElement root = doc.RootElement;

				string phrase = "";
				if (root.TryGetProperty("partial", out JsonElement partialElement))
				{
					phrase = partialElement.GetString();
				}

				if (!string.IsNullOrEmpty(phrase))
				{
					partialResultText.Text = phrase;
					phraseManager.Call("mark_phrase_as_used", phrase);
				}
			}
			catch (Exception ex)
			{
				GD.Print("Error parsing JSON: ", ex.Message);
			}
		};
		speechRecognizer.OnFinalResult += (finalResult) =>
		{
			
			try
			{
				using JsonDocument doc = JsonDocument.Parse(finalResult);
				JsonElement root = doc.RootElement;

				string phrase = "";
				if (root.TryGetProperty("text", out JsonElement partialElement))
				{
					phrase = partialElement.GetString();
				}

				if (!string.IsNullOrEmpty(phrase))
				{
					finalResultText.Text = phrase;
					phraseManager.Call("mark_phrase_as_used", phrase);
				}
			}
			catch (Exception ex)
			{
				GD.Print("Error parsing JSON: ", ex.Message);
			}
			
			OnStopSpeechRecognition();
		};
	}

	public override void _Process(double delta)
	{
		
	 	
	}
	
	

	private void OnStopSpeechRecognition()
	{
		startButton.Text = "Start Recognition";
		startButton.Modulate = new Color(1, 1, 1, 1f);
	}
	private void OnStartSpeechRecognition()
	{
		startButton.Text = "Stop Recognition";
		startButton.Modulate = new Color(1f, 0.5f, 0.5f, 1f);
	}
}
