package cli

import (
	"fmt"

	"github.com/taylor-ken/gator/internal/config"
)

type State struct {
	Config *config.Config
}

type Command struct {
	Name string
	Args []string
}

type Commands struct {
	Handlers map[string]func(*State, Command) error
}

func HandlerLogin(s *State, cmd Command) error {
	if len(cmd.Args) < 1 {
		return fmt.Errorf("Error: no username")
	}
	err := s.Config.SetUser(cmd.Args[0])
	if err != nil {
		return fmt.Errorf("Couldn't set current user: %w", err)
	}
	fmt.Println("Username set")
	return nil
}

func (c *Commands) Run(s *State, cmd Command) error {
	handler := c.Handlers[cmd.Name]
	if handler == nil {
		return fmt.Errorf("No such command")
	}
	return handler(s, cmd)
}

func (c *Commands) Register(name string, f func(*State, Command) error) {
	c.Handlers[name] = f
}
