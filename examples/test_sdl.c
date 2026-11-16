#include <SDL3/SDL.h>
#include <stdio.h>
#include <stdbool.h>

int main(int argc, char* argv[]) {
    printf("=== SDL3 Termux-X11 Test ===\n");
    printf("SDL3 Version: %d.%d.%d\n", SDL_MAJOR_VERSION, SDL_MINOR_VERSION, SDL_MICRO_VERSION);

    if (!SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS)) {
        fprintf(stderr, "Error SDL_Init: %s\n", SDL_GetError());
        return 1;
    }

    printf("Active Video Driver: %s\n", SDL_GetCurrentVideoDriver());

    SDL_Window* window = SDL_CreateWindow("Termux-X11 SDL3 Demo", 800, 600, SDL_WINDOW_RESIZABLE);
    if (!window) {
        fprintf(stderr, "Error SDL_CreateWindow: %s\n", SDL_GetError());
        SDL_Quit();
        return 1;
    }

    SDL_Renderer* renderer = SDL_CreateRenderer(window, NULL);
    if (!renderer) {
        fprintf(stderr, "Error SDL_CreateRenderer: %s\n", SDL_GetError());
        SDL_DestroyWindow(window);
        SDL_Quit();
        return 1;
    }

    printf("Window created! Press 'Q' or close window to exit.\n");

    bool running = true;
    SDL_Event event;
    float hue = 0.0f;

    while (running) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_EVENT_QUIT) {
                running = false;
            } else if (event.type == SDL_EVENT_KEY_DOWN) {
                if (event.key.key == SDLK_Q || event.key.key == SDLK_ESCAPE) {
                    running = false;
                }
            }
        }

        // Animate background color
        hue += 0.01f;
        if (hue > 1.0f) hue = 0.0f;

        float r = 0.5f + 0.5f * SDL_sinf(hue * 6.28f);
        float g = 0.5f + 0.5f * SDL_sinf(hue * 6.28f + 2.09f);
        float b = 0.5f + 0.5f * SDL_sinf(hue * 6.28f + 4.18f);

        SDL_SetRenderDrawColorFloat(renderer, r, g, b, 1.0f);
        SDL_RenderClear(renderer);

        // Draw a central rectangle
        SDL_FRect rect = { 250.0f, 175.0f, 300.0f, 250.0f };
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        SDL_RenderFillRect(renderer, &rect);

        SDL_RenderPresent(renderer);
        SDL_Delay(16); // ~60 FPS
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    printf("Demo finished successfully.\n");
    return 0;
}
