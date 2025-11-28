import { describe, it, expect, vi, beforeEach } from 'vitest';
import { GeocodingService } from '../../../src/services/geocoding.service';

describe('GeocodingService', () => {
	beforeEach(() => {
		vi.resetAllMocks();
	});

	it('should call Open-Meteo geocoding endpoint with provided params', async () => {
		const mockResponse = {
			results: [
				{
					name: 'Berlin',
					latitude: 52.52,
					longitude: 13.41,
					country: 'Germany',
					admin1: 'Berlin',
				},
			],
		};

		global.fetch = vi.fn().mockResolvedValue({
			ok: true,
			json: async () => mockResponse,
		});

		const service = new GeocodingService();
		await service.searchCity('Berlin', { count: 3, language: 'de' });

		expect(fetch).toHaveBeenCalledWith(
			expect.stringContaining('https://geocoding-api.open-meteo.com/v1/search')
		);
		expect(fetch).toHaveBeenCalledWith(expect.stringContaining('name=Berlin'));
		expect(fetch).toHaveBeenCalledWith(expect.stringContaining('count=3'));
		expect(fetch).toHaveBeenCalledWith(expect.stringContaining('language=de'));
	});

	it('should normalize forward geocoding results from Open-Meteo', async () => {
		const mockResponse = {
			results: [
				{
					name: 'Paris',
					latitude: 48.8566,
					longitude: 2.3522,
					country: 'France',
					admin1: 'Île-de-France',
					admin2: 'Paris',
					timezone: 'Europe/Paris',
				},
			],
		};

		global.fetch = vi.fn().mockResolvedValue({
			ok: true,
			json: async () => mockResponse,
		});

		const service = new GeocodingService();
		const location = await service.getLocationByCity('Paris');

		expect(location).toEqual(
			expect.objectContaining({
				name: 'Paris',
				latitude: 48.8566,
				longitude: 2.3522,
				country: 'France',
				state: 'Île-de-France',
				county: 'Paris',
				source: 'forward',
			})
		);
	});

	it('should return null when no geocoding match is found', async () => {
		global.fetch = vi.fn().mockResolvedValue({
			ok: true,
			json: async () => ({ results: [] }),
		});

		const service = new GeocodingService();
		const result = await service.getLocationByCity('Unknown City');
		expect(result).toBeNull();
	});

	it('should call reverse geocoding API with API key and normalize response', async () => {
		const mockReverse = {
			display_name: 'Berlin, Germany',
			address: {
				city: 'Berlin',
				country: 'Germany',
				state: 'Berlin',
				county: 'Berlin',
			},
		};

		global.fetch = vi.fn().mockResolvedValue({
			ok: true,
			json: async () => mockReverse,
		});

		const service = new GeocodingService('secret');
		const location = await service.reverseGeocode(52.52, 13.41);

		expect(fetch).toHaveBeenCalledWith(exp expect.stringContaining('api_key=secret'));
		expect(location).toEqual(
			expect.objectContaining({
				name: 'Berlin',
				displayName: 'Berlin, Germany',
				country: 'Germany',
				source: 'reverse',
			})
		);
	});

	it('should throw an error on reverse geocoding failure', async () => {
		global.fetch = vi.fn().mockResolvedValue({
			ok: false,
			json: async () => ({ error: 'Invalid request' }),
		});

		const service = new GeocodingService('secret');
		await expect(service.reverseGeocode(0, 0)).rejects.toThrow('Invalid request');
	});
});
