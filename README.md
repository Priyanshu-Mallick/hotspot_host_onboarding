# Hotspot Host Onboarding

## Overview

Hotspot Host Onboarding is a comprehensive onboarding questionnaire platform that allows users to record and submit audio and video responses. This project is designed to provide an intuitive and seamless experience for users to become hosts on the platform.

---

## Features

### 1. **Onboarding Questionnaire**
- Interactive questionnaire designed for hosts to submit their responses.
- Users can type or record audio/video responses for specific questions.

### 2. **Audio Recording**
- Custom-built audio recording feature using Riverpod state management.
- Real-time audio wave visualization to show recording status.
- Ability to pause, resume, and delete recordings.
- Saved audio stored in cache for later use.
- Recording status is displayed clearly, including the elapsed time and user control options like delete and finalize.

### 3. **Video Recording**
- Custom-built video recorder with a previewer for recorded content.
- Users can review recorded videos before submission.
- Videos are stored temporarily in cache until the user finalizes their submission.
- Full control over starting, stopping, and deleting recorded videos.

---

## Brownie Points (Bonus Features)

### 1. **Custom Audio Wave Visualization**
- A fully custom-designed audio wave widget to provide real-time feedback during audio recordings.
- Implemented dynamic audio wave bars for an engaging user experience.

### 2. **Gradient Effects and Visual Design**
- Consistent use of gradients and effects to enhance visual appeal across the platform.
- Seamless transitions between various states (idle, recording, reviewing).

### 3. **Responsive UI**
- Adaptive UI components that adjust to screen size for a smooth experience on both mobile and tablet devices.

---

## Additional Features & Enhancements

### 1. **Custom Video Recording & Preview**
- Custom video recording module integrated with user-friendly preview functionality.
- Implemented a seamless transition between recording and reviewing videos before submission.

### 2. **Caching Mechanism**
- All recorded media (audio and video) are cached to avoid unnecessary re-recording if users navigate away from the page.
- Cached media can be easily retrieved and modified before submission.

### 3. **Optimized State Management**
- Efficient use of Riverpod for managing multiple states such as recording status, video previews, and form submission states.

### 4. **Improved Error Handling**
- Robust error handling and validation to ensure a smooth user experience.
- Clear feedback messages for failed recordings or incomplete responses.
