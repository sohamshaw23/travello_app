from models.transport import TransportOption


class RouteReasoningService:
    def explain(self, option: TransportOption, cheapest_cost: int, fastest_minutes: int) -> str:
        option_minutes = self._minutes(option.total_time)

        if option.total_cost == cheapest_cost:
            return (
                "This route is cheapest because it leans on public transport and walking, "
                "keeping the per-kilometer fare low with manageable transfers."
            )

        if option_minutes == fastest_minutes:
            return (
                "This route is fastest because it prioritizes direct high-speed segments, "
                "reducing total travel time at a higher fare."
            )

        return (
            "This route is balanced because it avoids the highest auto fares while cutting down "
            "travel time compared with the lowest-cost option."
        )

    def _minutes(self, value: str) -> int:
        return int(value.split()[0])
